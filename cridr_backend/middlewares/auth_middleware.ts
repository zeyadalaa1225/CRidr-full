import jwt from "jsonwebtoken";

export const authmiddleware=(req,res,next)=>{
   try {
     const headertoken = req.headers.authorization;
     
    if(!headertoken){
        res.status(401).json({message:"Authorization header missing"});
    }
    else {
       const token=headertoken.split(" ")[1];
       if (!token) {
      return res.status(401).json({ message: "Token missing" });
    }
       const decoded=jwt.verify(token,process.env.JWT_SECRET);
       
      req.user = { id: decoded.id };
next();
    }
   } catch (error) {
    return res.status(403).json({ message: "Invalid or expired token" });
   }
    
}