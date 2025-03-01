//
//  WorkoutService.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import Foundation

protocol WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func logWorkout(activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async throws -> String
    func deleteWorkout(workoutId: Int) async throws -> String
    func editWorkout(workoutId: Int, activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async throws -> String
}

final class WorkoutService: WorkoutServiceProtocol {
    private let baseURL = "http://localhost:5001"
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchWorkouts() async throws -> [Workout] {
        let url = URL(string: "\(baseURL)/workouts")!
        let headers = TokenManager.shared.authHeader()
        return try await networkManager.performRequest(url: url, method: .GET, body: nil, headers: headers)
    }
    
    func logWorkout(activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async throws -> String {
        let url = URL(string: "\(baseURL)/workouts")!
        let parameters = ["activity": activity, "duration": "\(duration)", "caloriesBurned": "\(caloriesBurned)"]
        let headers = TokenManager.shared.authHeader()
        
        let response: WorkoutResponse = try await networkManager.uploadRequest(
            url: url,
            method: .POST,
            parameters: parameters,
            imageData: imageData,
            imageName: "workout.jpg",
            headers: headers
        )
        
        return response.message
    }
    
    func deleteWorkout(workoutId: Int) async throws -> String {
        let url = URL(string: "\(baseURL)/workouts/\(workoutId)")!
        let headers = TokenManager.shared.authHeader()
        
        let response: WorkoutResponse = try await networkManager.performRequest(
            url: url,
            method: .DELETE,
            body: nil,
            headers: headers
        )
        
        return response.message
    }
    
    func editWorkout(workoutId: Int, activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async throws -> String {
        let url = URL(string: "\(baseURL)/workouts/\(workoutId)")!
        let parameters: [String: String] = [
            "activity": activity,
            "duration": "\(duration)",
            "caloriesBurned": "\(caloriesBurned)"
        ]
        let headers = TokenManager.shared.authHeader()

        if let imageData = imageData {
            print("Uploading image with workout update")
            let response: WorkoutResponse = try await networkManager.uploadRequest(
                url: url,
                method: .PUT,
                parameters: parameters,
                imageData: imageData,
                imageName: "workout.jpg",
                headers: headers
            )
            return response.message
        } else {
            print("Updating workout without image")
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            let response: WorkoutResponse = try await networkManager.performRequest(
                url: url,
                method: .PUT,
                body: jsonData,
                headers: headers
            )
            return response.message
        }
    }
}
