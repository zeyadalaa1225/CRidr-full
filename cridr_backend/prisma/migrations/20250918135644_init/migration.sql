-- CreateTable
CREATE TABLE "public"."User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "Type" BOOLEAN NOT NULL DEFAULT true,
    "longitude" DOUBLE PRECISION,
    "latitude" DOUBLE PRECISION,
    "Status" TEXT,
    "OTP" TEXT,
    "otpExpiresAt" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Request" (
    "id" SERIAL NOT NULL,
    "issueType" TEXT NOT NULL,
    "carYear" INTEGER NOT NULL,
    "carMake" TEXT NOT NULL,
    "carModel" TEXT NOT NULL,
    "carColor" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "requestTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    "providerId" INTEGER,
    "cost" INTEGER,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "Request_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- AddForeignKey
ALTER TABLE "public"."Request" ADD CONSTRAINT "Request_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Request" ADD CONSTRAINT "Request_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;


-- Insert Users
INSERT INTO "public"."User" (name, email, password, "phoneNumber", "Type", longitude, latitude, "Status")
VALUES
('Alice Johnson', 'alice@example.com', 'password123', '1234567890', true, 31.2156, 30.0444, 'active'),
('Bob Smith', 'bob@example.com', 'password123', '0987654321', true, 31.2200, 30.0500, 'active'),
('Charlie Brown', 'charlie@example.com', 'password123', '1112223333', false, 31.2300, 30.0600, 'active'),
('Diana Prince', 'diana@example.com', 'password123', '4445556666', false, 31.2400, 30.0700, 'active'),
('Ethan Hunt', 'ethan@example.com', 'password123', '7778889999', true, 31.2500, 30.0800, 'inactive');

-- Insert Requests
INSERT INTO "public"."Request"
("issueType", "carYear", "carMake", "carModel", "carColor", "notes", cost, "userId", "providerId", latitude, longitude,"status")
VALUES
('Engine Issue', 2015, 'Toyota', 'Corolla', 'White', 'Engine makes strange noise', 1000, 1, 3, 30.0444, 31.2156,'Accepted'),
('Flat Tire', 2018, 'Honda', 'Civic', 'Black', 'Rear tire flat', 2000, 2, 3, 30.0500, 31.2200,'Completed'),
('Battery Dead', 2017, 'Ford', 'Focus', 'Red', 'Battery needs replacement', 1200, 1, 4, 30.0600, 31.2300,'Cancelled'),
('Brake Failure', 2016, 'BMW', '320i', 'Blue', 'Brake pads worn out', 2300, 5, 4, 30.0700, 31.2400,'Pending'),
('Overheating', 2020, 'Hyundai', 'Elantra', 'Silver', 'Car overheating on highway', 4500, 2, 3, 30.0800, 31.2500,'Pending');
