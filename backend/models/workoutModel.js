const db = require("../config/db");

const Workout = {
    create: async (userId, activity, duration, caloriesBurned, imageUrl) => {
        const [result] = await db.query(
            "INSERT INTO workouts (user_id, activity, duration, calories_burned, image_url) VALUES (?, ?, ?, ?, ?)",
            [userId, activity, duration, caloriesBurned, imageUrl || null]
        );
        return result;
    },

    getAllByUser: async (userId) => {
        const [rows] = await db.query(
            "SELECT * FROM workouts WHERE user_id = ? ORDER BY created_at DESC",
            [userId]
        );
        return rows;
    },

    getById: async (workoutId) => {
        const [rows] = await db.query(
            "SELECT * FROM workouts WHERE id = ?",
            [workoutId]
        );
        return rows.length > 0 ? rows[0] : null;
    },

    update: async (workoutId, activity, duration, caloriesBurned, imageUrl) => {
        try {
            console.log("Updating Workout in DB:", { workoutId, activity, duration, caloriesBurned, imageUrl });

            const result = await db.query(
                "UPDATE workouts SET activity = ?, duration = ?, calories_burned = ?, image_url = COALESCE(?, image_url) WHERE id = ?",
                [activity, duration, caloriesBurned, imageUrl, workoutId]
            );

            return result[0];
        } catch (error) {
            console.error("Database Update Error:", error);
            throw error;
        }
    },

    delete: async (workoutId, userId) => {
        const [result] = await db.query(
            "DELETE FROM workouts WHERE id = ? AND user_id = ?",
            [workoutId, userId]
        );
        return result;
    }
};

module.exports = Workout;