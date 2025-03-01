const express = require("express");
const { authenticate, authorizeAdmin } = require("../middleware/authMiddleware");
const db = require("../config/db");

const router = express.Router();

router.get("/users", authenticate, authorizeAdmin, async (req, res) => {
    try {
        const [users] = await db.execute("SELECT id, name, email, role, created_at FROM users");
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.get("/workouts", authenticate, authorizeAdmin, async (req, res) => {
    try {
        const [workouts] = await db.execute(`
            SELECT workouts.*, users.name AS user_name 
            FROM workouts 
            JOIN users ON workouts.user_id = users.id
            ORDER BY workouts.created_at DESC
        `);
        res.json(workouts);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
