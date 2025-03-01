require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const db = require("./config/db");

const workoutRoutes = require("./routes/workoutRoutes");
const authRoutes = require("./routes/authRoutes");
const adminRoutes = require("./routes/adminRoutes");

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use("/workouts", workoutRoutes);
app.use("/auth", authRoutes);
app.use("/admin", adminRoutes);

const PORT = process.env.PORT || 5001;

app.get("/", (req, res) => {
    res.json({ message: "Welcome to the API" });
});

app.listen(PORT, () => {
    console.log("Available Routes:");
    app._router.stack.forEach((r) => {
        if (r.route && r.route.path) {
            console.log(`${Object.keys(r.route.methods).join(", ").toUpperCase()} ${r.route.path}`);
        }
    });
    console.log(`Server running on port ${PORT}`);
});
