# 🏋️‍♂️ Workout History App

A **full-stack workout tracking app** that allows users to **log, edit, delete, and view their workouts** with **image uploads to AWS S3**. The app includes:
- **iOS (Swift, SwiftUI)** front-end
- **Node.js & Express** backend with JWT authentication
- **MySQL database**
- **AWS S3** for storing workout images
- **React.js (Admin Panel)** (coming soon)

---

## 🚀 Technologies Used
### **Frontend (iOS - Swift)**
- **Swift & SwiftUI** – UI development
- **Combine & Async/Await** – Data fetching & state management
- **PhotosPicker & Image Processing** – Image selection & optimization
- **Custom Image Caching** – Faster image loading

### **Backend (Node.js & MySQL)**
- **Node.js & Express.js** – REST API
- **MySQL (MySQL2)** – Database for storing workouts & users
- **AWS S3 (SDK v3)** – Image storage
- **Multer** – File uploads handling
- **JWT Authentication** – Secure login & user management

---

## 🔧 Installation Guide

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/WorkoutHistory.git
cd WorkoutHistory
```

### **2️⃣ Backend Setup**
#### **📦 Install Dependencies**
```sh
cd backend
npm install
```

#### **🔑 Set Up Environment Variables**
Create a `.env` file inside the `backend/` folder and configure:
```ini
PORT=5001
DB_HOST=localhost
DB_USER=root
DB_PASS=yourpassword
DB_NAME=lungeapp_workout

JWT_SECRET=your_jwt_secret

AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=your_region
AWS_BUCKET_NAME=your_bucket_name
```

#### **📄 Start MySQL & Run Database Setup**
Ensure **MySQL is running**, then:
```sh
mysql -u root -p
```
Manually create the database:
```sql
CREATE DATABASE IF NOT EXISTS lungeapp_workout;
```
Then run:
```sh
npm start
```
👌 **Backend should be running at** `http://localhost:5001`

---

### **3️⃣ iOS Setup**
#### **📦 Install Dependencies**
```sh
cd mobile
open WorkoutHistory.xcodeproj
```
- **Ensure Xcode is set up correctly**.
- **Run the app in a simulator or device**.

---

## 🚀 Running the App

### **Start Backend**
```sh
cd backend
npm start
```

### **Start iOS App**
- Open **WorkoutHistory.xcodeproj** in Xcode
- Select a **simulator** or device
- Press **Run ▶**

---

## 📞 API Endpoints
| Method | Endpoint             | Description              | Auth Required |
|--------|----------------------|--------------------------|--------------|
| **POST**  | `/auth/signup`         | Register a new user      | ❌ No |
| **POST**  | `/auth/login`          | Login & receive JWT      | ❌ No |
| **GET**   | `/workouts`            | Get user's workouts      | ✅ Yes |
| **POST**  | `/workouts`            | Log a new workout        | ✅ Yes |
| **PUT**   | `/workouts/:id`        | Edit a workout           | ✅ Yes |
| **DELETE**| `/workouts/:id`        | Delete a workout         | ✅ Yes |

---

## 📸 Image Upload & AWS S3
- Users can upload images when **logging or editing workouts**.
- Images are **compressed before upload** to improve performance.
- Images are stored securely in **AWS S3**.

---

## 🛠️ Future Enhancements
- **React.js Admin Panel** for monitoring workouts
- **User Profiles & Advanced Analytics**
- **Push Notifications for Workout Reminders**
- **AI-Powered Workout Suggestions**

---

## 📝 License
This project is **open-source** and available under the **MIT License**.

📩 Need help? Contact **your_email@example.com**

