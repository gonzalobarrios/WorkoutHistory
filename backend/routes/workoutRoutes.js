const express = require("express");
const multer = require("multer");
const { authenticate } = require("../middleware/authMiddleware");
const workoutController = require("../controllers/workoutController");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.post("/", authenticate, upload.single("image"), workoutController.createWorkout);
router.get("/", authenticate, workoutController.getUserWorkouts);
router.put("/:id", authenticate, upload.single("image"), workoutController.updateWorkout);
router.delete("/:id", authenticate, workoutController.deleteWorkout);

module.exports = router;
