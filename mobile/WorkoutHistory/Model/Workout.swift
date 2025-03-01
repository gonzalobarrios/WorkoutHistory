//
//  Workout.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

struct Workouts: Codable {
    let workouts: [Workout]
}

struct Workout: Codable, Identifiable {
    let id: Int
    var activity: String
    var duration: Int
    var caloriesBurned: Int
    var imageUrl: String?
    var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case activity
        case duration
        case caloriesBurned = "calories_burned"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}

struct WorkoutResponse: Codable {
    let message: String
}
