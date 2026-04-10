import { Server, Socket } from "socket.io";
import { Server as HTTPServer } from "http";
import { PrismaClient } from "@prisma/client";
import jwt from "jsonwebtoken";

const prisma = new PrismaClient();

// Extend socket type to include userId
interface MySocket extends Socket {
  userId?: number; // Prisma userId is numeric
}

export default function initSocket(httpserver: HTTPServer) {
  console.log("socket initialized");

  const io = new Server(httpserver, {
    cors: {
      origin: "*", // allow all clients (Flutter included)
      methods: ["GET", "POST"],
    },
  });

  // 🔹 Middleware: authenticate user by JWT
  io.use((socket: MySocket, next) => {
    console.log("socket middleware");
    try {
      const token = socket.handshake.auth.token;
      if (!token) {
        return next(new Error("No token provided"));
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET!) as { id: number };
      socket.userId = decoded.id; // save user id on socket
      next();
    } catch (err) {
      next(new Error("Authentication failed"));
    }
  });

  // 🔹 Main connection handler
  io.on("connection", (socket: MySocket) => {
    console.log("a user connected:", socket.id);

    // Optional: manual register (not needed if JWT works, but you kept it)
    socket.on("register", (userId: number) => {
      socket.userId = userId;
      console.log(`User ${userId} registered with socket ${socket.id}`);
    });

    // 🔹 Handle request creation
    socket.on("request", async (data) => {
      console.log("Received request:", data);
      try {
        if (!socket.userId) {
          return socket.emit("request:error", { message: "Unauthorized" });
        }

        const { issueType, carYear, carMake, carModel, carColor, latitude, longitude, notes } = data;

        // --- Cost Calculation ---
        let cost = 0;
        if (issueType === "Tire Change") cost += 1000;
        else if (issueType === "Tow Truck") cost += 2000;
        else if (issueType === "Jump Start") cost += 3000;
        else if (issueType === "Fuel Delivery") cost += 4000;
        else cost += 5000;

        // Weekend surcharge (Saturday=6, Sunday=0)
        if (new Date().getDay() === 6 || new Date().getDay() === 0) {
          cost *= 1.3;
        }

        // Night surcharge (after 8pm or before 8am)
        const hour = new Date().getHours(); // returns 0–23
        if (hour > 20 || hour < 8) {
          cost *= 1.2;
        }

        // --- Create request in DB ---
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
            userId: socket.userId, // attach from authenticated socket
            cost,
            status: "Pending",
          },
        });

        // Notify all clients
        io.emit("request:success", {
          message: "Request created successfully",
          request,
        });

        // 🔹 Update request price
        socket.on("request:price", async (data) => {
          const { requestId, price } = data;

          let request = await prisma.request.findUnique({
            where: { id: requestId },
          });

          if (request) {
            request = await prisma.request.update({
              where: { id: requestId },
              data: { cost: price },
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

            io.emit("request:update", {
              message: "Price updated successfully",
              request,
            });
          } else {
            socket.emit("request:update:error", { message: "Request not found" });
          }
        });

        // 🔹 Accept request

      } catch (error) {
        console.error("Error creating request:", error);
        socket.emit("request:error", { message: "Internal server error" });
      }
    });
        socket.on("request:accept", async (data) => {
          console.log("request:accept event:", data);

          const userId = socket.userId;
          const { requestId } = data;

          const user = await prisma.user.findUnique({
            where: { id: userId },
          });

          if (!user) {
            return socket.emit("request:accept:error", { message: "User not found" });
          }

          let request = await prisma.request.findUnique({
            where: { id: requestId },
          });

          if (!request) {
            io.emit("request:accept:error", { message: "Request not found" });
          } else {
            request = await prisma.request.update({
              where: { id: requestId },
              data: { status: "Accepted", providerId: userId },
            });

            io.emit("request:accept:success", {
              message: "Request accepted successfully",
              request,
            });
          }
        });
         socket.on("request:complete", async (data) => {
          console.log("request:complete event:", data);

          const userId = socket.userId;
          const { requestId } = data;

          const user = await prisma.user.findUnique({
            where: { id: userId },
          });

          if (!user) {
            return socket.emit("request:complete:error", { message: "User not found" });
          }

          let request = await prisma.request.findUnique({
            where: { id: requestId },
          });

          if (!request) {
            io.emit("request:complete:error", { message: "Request not found" });
          } else {
            request = await prisma.request.update({
              where: { id: requestId },
              data: { status: "Completed", providerId: userId },
            });

            io.emit("request:complete:success", {
              message: "Request completed successfully",
              request,
            });
          }
        });
        socket.on("request:cancel", async (data) => {
          console.log("request:cancel event:", data);

          const userId = socket.userId;
          const { requestId } = data;

          const user = await prisma.user.findUnique({
            where: { id: userId },
          });

          if (!user) {
            return socket.emit("request:cancel:error", { message: "User not found" });
          }

          let request = await prisma.request.findUnique({
            where: { id: requestId ,status:"Pending"},
          });

          if (!request) {
            io.emit("request:cancel:error", { message: "Request not found" });
          } else {
            request = await prisma.request.update({
              where: { id: requestId },
              data: { status: "Cancelled", providerId: userId },
            });

            io.emit("request:cancel:success", {
              message: "Request cancel successfully",
              request,
            });
          }
        });
    // 🔹 Disconnect
    socket.on("disconnect", () => {
      console.log("user disconnected:", socket.id);
    });
  });

  return io;
}
