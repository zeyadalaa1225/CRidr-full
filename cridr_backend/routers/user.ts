import express from "express";
import dotenv from "dotenv";
import { PrismaClient } from '@prisma/client';
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import  {authmiddleware}  from "../middlewares/auth_middleware.ts";
dotenv.config();

const prisma=new PrismaClient();

const router = express.Router();

router.put("/change-location",authmiddleware,async(req,res)=>{
    console.log(req.body);
    const {latitude,longitude}=req.body;
    
    const userId=req.user.id
    try {
        const user=await prisma.user.findUnique({
            where:{id:userId}
        })
        if(!user){
            return res.status(400).json({message:"User not found"});
        }
        const updateuser=await prisma.user.update({
            where:{id:req.user.id},
            data:{latitude:latitude,longitude:longitude}
        })
        if(!updateuser){
            return res.status(400).json({message:"User not found"});
        }
        console.log(updateuser);
        return res.status(200).json({message:"Location updated successfully"});
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }
})
router.get("/provider-location/:reqId", authmiddleware, async (req, res) => {
  const { reqId } = req.params;

  try {
    const request = await prisma.request.findUnique({
      where: { id: Number(reqId) }, // ensure id is numeric
    });

    if (!request) {
      return res.status(400).json({ message: "Request not found" });
    }

    const providerId = request.providerId;

    if (!providerId) {
      return res.status(400).json({ message: "Provider not assigned yet" });
    }

    const provider = await prisma.user.findUnique({
      where: { id: providerId },
      select: { latitude: true, longitude: true }, // optimization
    });

    if (!provider) {
      return res.status(400).json({ message: "Provider not found" });
    }

    return res.status(200).json({
      message: "Provider location",
      latitude: provider.latitude,
      longitude: provider.longitude,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export default router