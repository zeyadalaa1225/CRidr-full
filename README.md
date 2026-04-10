# 📱 CRidr - Full Stack Mobile App

CRidr is a full-stack mobile application built using **Flutter (frontend)** and **Node.js (backend)**.  
The project follows **Clean Architecture principles** on the Flutter side and uses **Cubit (Bloc state management)** for scalable and maintainable state handling.

---

## 🚀 Tech Stack

### 📱 Frontend (Flutter)
- Flutter
- Dart
- Cubit (Bloc State Management)
- Clean Architecture
- Dio (API handling)
- Shared Preferences

### 🖥 Backend
- Node.js
- Express.js
- Prisma ORM
- Socket.IO
- JWT Authentication
- RESTful APIs

### 🗄 Database
- PostgreSQL / MySQL (via Prisma)

---

## 🏗 Architecture

The Flutter app follows **Clean Architecture**:

- **Presentation Layer** → UI + Cubit
- **Domain Layer** → Entities + Use Cases
- **Data Layer** → Repositories + API/Data Sources

---

## ⚙️ Backend Structure

- Routes (Auth / User / Requests)
- Middleware (JWT Authentication)
- Socket.IO (Real-time communication)
- Prisma ORM (Database management)

---

## 🔐 Authentication

- JWT-based authentication
- Register & Login system
- Protected routes using middleware
- Token-based user sessions

---

## 🔄 Features

- User authentication (Register / Login)
- Profile management
- Request system (friends/relations depending on app logic)
- Real-time updates using Socket.IO
- Clean scalable Flutter architecture
- State management using Cubit

---
