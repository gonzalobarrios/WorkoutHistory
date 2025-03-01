const Workout = require("../models/workoutModel");
const multer = require("multer");
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
const s3 = require("../config/aws");
const crypto = require("crypto");
const path = require("path");

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

async function uploadToS3(file) {
    const fileName = `workout-images/${crypto.randomBytes(16).toString("hex")}${path.extname(file.originalname)}`;
    const uploadParams = {
        Bucket: process.env.AWS_BUCKET_NAME,
        Key: fileName,
        Body: file.buffer,
        ContentType: file.mimetype
    };

    const command = new PutObjectCommand(uploadParams);
    await s3.send(command);

    return `https://${process.env.AWS_BUCKET_NAME}.s3.${process.env.AWS_REGION}.amazonaws.com/${fileName}`;
}

const createWorkout = async (req, res) => {
    console.log("Incoming Workout Data:", req.body);
    console.log("File Received:", req.file);

    const { activity, duration, caloriesBurned } = req.body;
    const userId = req.user.id;
    let imageUrl = null;

    if (!activity || !duration || !caloriesBurned) {
        return res.status(400).json({ error: "Missing required fields" });
    }

    try {
        if (req.file) {
            imageUrl = await uploadToS3(req.file);
        }

        console.log("Inserting workout into database:", { userId, activity, duration, caloriesBurned, imageUrl });

        const result = await Workout.create(userId, activity, duration, caloriesBurned, imageUrl);

        if (!result.insertId) {
            throw new Error("Workout was not inserted");
        }

        res.status(201).json({ message: "Workout logged", workoutId: result.insertId, imageUrl });
    } catch (error) {
        console.error("Workout Logging Error:", error);
        res.status(500).json({ error: error.message });
    }
};

const getUserWorkouts = async (req, res) => {
    try {
        const workouts = await Workout.getAllByUser(req.user.id);
        res.json(workouts);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updateWorkout = async (req, res) => {
    const { activity, duration, caloriesBurned } = req.body;
    const workoutId = req.params.id;
    let imageUrl = null;

    if (!activity || !duration || !caloriesBurned) {
        return res.status(400).json({ error: "Missing required fields" });
    }

    try {
        const existingWorkout = await Workout.getById(workoutId);

        if (!existingWorkout) {
            return res.status(404).json({ error: "Workout not found" });
        }

        if (req.file) {
            imageUrl = await uploadToS3(req.file);
        } else {
            imageUrl = existingWorkout.image_url;
        }

        console.log("Updating Workout:", { workoutId, activity, duration, caloriesBurned, imageUrl });

        const result = await Workout.update(workoutId, activity, duration, caloriesBurned, imageUrl);

        if (!result || result.affectedRows === 0) {
            return res.status(400).json({ error: "Workout update failed" });
        }

        res.status(200).json({ message: "Workout updated successfully", imageUrl });
    } catch (error) {
        console.error("Error updating workout:", error);
        res.status(500).json({ error: error.message });
    }
};

const deleteWorkout = async (req, res) => {
    try {
        await Workout.delete(req.params.id, req.user.id);
        res.json({ message: "Workout deleted" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    createWorkout,
    getUserWorkouts,
    updateWorkout,
    deleteWorkout
};