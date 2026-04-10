import express from "express";
import dotenv from "dotenv";
import { PrismaClient } from '@prisma/client';
import  {authmiddleware}  from "../middlewares/auth_middleware.ts";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";
import { sendEmail } from "../utils/sendemail.ts";

dotenv.config();

const prisma=new PrismaClient();

const router = express.Router();

router.post("/register", async (req, res) => {
    try {
        const{name,email,password,phoneNumber,role}=req.body;
        const hashedPassword=await bcrypt.hash(password,10);
        const isexist=await prisma.user.findFirst({
            where:{email:email}
        })
        if(isexist){
            return res.status(400).json({message:"User already exists"});
        }
        const user=await prisma.user.create({
            data:{name:name,email:email,password:hashedPassword,phoneNumber:phoneNumber,Type:role}
        })
        console.log(user);
        if(user){
            const token = jwt.sign({id:user.id},process.env.JWT_SECRET,{expiresIn:"1d"});
            console.log("Type",user.Type);
            return res.status(201).json({message:"User created successfully",token:token,role:user.Type,id:user.id});
        }
        else 
        {
            return res.status(400).json({message:"User not created"});
        }
    } catch (error) {
        res.status(500).json({message:"Internal server error"});
    }
})
router.post("/login",async(req,res)=>{
    const{email,password}=req.body;
    try {
        const user=await prisma.user.findFirst({
            where:{email:req.body.email}
    
        })
        if(user){
            const isMatch = await bcrypt.compare(password,user.password);
            if(isMatch){
                const token=jwt.sign({id:user.id},process.env.JWT_SECRET,{expiresIn:"1d"});
                return res.status(200).json({message:"Login successful",token:token,role:user.Type,id:user.id});
            }
            else 
            {
                return res.status(400).json({message:"Invalid password"});
            }
        }
        else 
        {
            res.status(400).json({message:"User not found"});
        }
    } catch (error) {
        res.status(500).json({message:"Internal server error",error:error});
    }
})

router.put("/reset-password",authmiddleware,async(req,res)=>{
const{oldpassword,newpassword}=req.body;
try {
    const user=await prisma.user.findFirst({
where:{id:req.user.id}
    })
    if(user){
        const isMatch = await bcrypt.compare(oldpassword,user.password);
        if(isMatch){
            const hashedPassword=await bcrypt.hash(newpassword,10);
           const updateuser=await prisma.user.update({
            data:{password:hashedPassword},
            where:{id:user.id}
           })
            return res.status(200).json({message:"Password reset successful"});
        }
        else 
        {
            return res.status(400).json({message:"Invalid old password"});
        }
    }
    else 
    {
        res.status(400).json({message:"User not found"});
    }
} catch (error) {
 res.status(500).json({message:"Internal server error"});   
}
})


router.post("/forget-password",async(req,res)=>{
    const {email}=req.body;
    try {
        const user= await prisma.user.findFirst({
            where:{email:email}
        })
        if(user===null){
            return res.status(400).json({message:"User not found"});
        }
        else{
            let OTP=Math.floor(100000+Math.random()*900000);
            // OTP=bcrypt.hashSync(OTP.toString(),10);
            await prisma.user.update({
                where:{id:user.id},
                data:{OTP:OTP.toString(),otpExpiresAt:new Date(Date.now()+15*60*1000)}
            })
            console.log(OTP);
            await sendEmail(email,"OTP for password reset",`Your OTP for password reset is ${OTP}`);
            return res.json({ message: "OTP sent to your email" });
        }
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }
})
router.post("/verify-otp",async(req,res)=>{
    const{email,otp}=req.body;
    console.log(email,otp);
    try {
        const user=await prisma.user.findFirst({
        where:{email:email}
    })
    if(!user||!user.OTP||!user.otpExpiresAt){
       return res.status(400).json({ message: "Invalid request" });
    }
    else 
    {
        if(user.otpExpiresAt<new Date())
        {
            return res.status(400).json({ message: "OTP has expired" });
        }
        const ischecked=user.OTP==otp;
        console.log(ischecked);
        if(!ischecked)
        {
            return res.status(400).json({ message: "Invalid OTP" });
        }
            await prisma.user.update({
      where: { email },
      data: { OTP: null, otpExpiresAt: null }
    });
    const resetToken = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "10m" } 
    );

    res.json({ message: "OTP verified. Use reset token to reset password.","resetToken": resetToken });
    }
    } catch (error) {
        return res.status(500).json({message:"Internal server error"});
    }

})
router.post("/reset-password", async (req, res) => {
  try {
    const { resetToken, newPassword } = req.body;

    if (!resetToken) {
      return res.status(401).json({ message: "Reset token required" });
    }

    let decoded;
    try {
      decoded = jwt.verify(resetToken, process.env.JWT_SECRET);
    } catch (err) {
      return res.status(403).json({ message: "Invalid or expired reset token" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await prisma.user.update({
      where: { id: decoded.id },
      data: { password: hashedPassword }
    });

    res.json({ message: "Password reset successful" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;