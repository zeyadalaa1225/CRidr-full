import express from "express";
import dotenv from "dotenv";
import { PrismaClient } from '@prisma/client';
import  {authmiddleware}  from "../middlewares/auth_middleware.ts";
import bcrypt from "bcrypt";

dotenv.config();

const prisma=new PrismaClient();
const router = express.Router();

router.post("/request",authmiddleware,async(req,res)=>{
    const {issueType,carYear,carMake,carModel,carColor,latitude,longitude,notes}=req.body;
    const userId=req.user.id;

    try {
      const user=await prisma.user.findUnique({
        where:{id:userId}
      })
      if(!user)
      {
        return res.status(400).json({message:"User not found"});
      }
      const basePrices: Record<string, number> = {
      "Tow Truck": 1000,
      "Tire Change": 500,
      "Jump Start": 400,
      "Fuel Delivery": 600,
      "Locked in": 700,
    };

    let cost = basePrices[issueType] ?? 500; // default if unknown

    // 2. Check date/time
    const now = new Date();
    const day = now.getDay(); // 0 = Sunday, 6 = Saturday
    const hour = now.getHours();

    // Weekend multiplier
    if (day === 0 || day === 6) {
      cost *= 1.2; // 20% higher on weekend
    }

    // Very late night (10pm–5am) multiplier
    if (hour >= 22 || hour < 5) {
      cost *= 1.3; // 30% higher at night
    }

    // Round cost to nearest integer
    cost = Math.round(cost);
const status='Pending';
        const request = await prisma.request.create({
  data: {
    issueType,
    carYear,
    carMake,
    carModel,
    carColor,
    notes,
    latitude,
    longitude,
    userId: req.user.id,
    cost: cost,
    status: status,
  },
});

        return res.status(200).json({message:"Request created successfully"});
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }
})

router.get("/allrequest",authmiddleware,async(req,res)=>{
    try {
       const userId=req.user.id;
       const user=await prisma.user.findUnique({
         where:{
           id:userId
         }
       })
       if(user?.Type)
       {
        return res.status(400).json({message:"Unauthorized"});
       }
       else 
       {
        const requests=await prisma.request.findMany();
        if(requests){
            return res.status(200).json({message:"All requests",requests:requests});
        }
        else 
        {
            return res.status(400).json({message:"No requests found"});
       }
       }
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }
})

router.get("/myrequests",authmiddleware,async(req,res)=>{
    try {
        const userId=req.user.id;

        const requests=await prisma.request.findMany({
            where:{userId:userId}
        })
        if(requests){
            return res.status(200).json({message:"My requests",requests:requests});
        }
        else 
        {
            return res.status(400).json({message:"No requests found"});
       }
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }
})

function getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of earth in km
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}
router.get("/PendingRequests", authmiddleware, async (req, res) => {
  const userId = req.user.id;

  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (user?.Type) {
      return res.status(400).json({ message: "Unauthorized" });
    }

    if (!user.latitude || !user.longitude) {
      return res.status(400).json({ message: "User does not have location info" });
    }

    
    const requests = await prisma.request.findMany({
      where: { status: "Pending" },
      include: {
        user: {
          select: {
            id: true,
            name: true,
            phoneNumber: true, 
          },
        },
      },
    });

    
    const nearbyRequests = requests.filter((req) => {
      if (!req.latitude || !req.longitude) return false;
      const distance = getDistanceFromLatLonInKm(
        user.latitude!,
        user.longitude!,
        req.latitude,
        req.longitude
      );
      return distance <= 10;
    });

    if (nearbyRequests.length === 0) {
      return res.status(404).json({ message: "No requests found within 10 km" });
    }

    return res.status(200).json({
      message: "Pending requests within 10 km",
      requests: nearbyRequests.map((req) => ({
        id: req.id,
        issueType: req.issueType,
        carMake: req.carMake,
        carModel: req.carModel,
        carYear: req.carYear,
        carColor: req.carColor,
        notes: req.notes,
        latitude: req.latitude,
        longitude: req.longitude,
        status: req.status,
        cost: req.cost,
        requestTime: req.requestTime,
        user: {
          id: req.user.id,
          name: req.user.name,
          phoneNumber: req.user.phoneNumber,
        },
      })),
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ message: "Internal server error" });
  }
});




export default router;