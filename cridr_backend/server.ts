import express from "express";
import dotenv from "dotenv";
import { PrismaClient } from '@prisma/client';
import authRouter from "./routers/auth.ts";
import reqRouter from "./routers/req.ts";
import userRouter from "./routers/user.ts";

import { createServer } from "http";
import { Server } from "socket.io";
import iniSocket from "./socket/index.ts";
dotenv.config();
const prisma = new PrismaClient();
const app = express(); 
const httpserver= createServer(app); 

const PORT = process.env.PORT || 3000;
app.use(express.json());
app.use("/auth", authRouter);
app.use("/req",reqRouter);
app.use("/user",userRouter);

app.get("/", (req, res) => {
    res.send("Hello World!");
})


iniSocket(httpserver);
httpserver.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});