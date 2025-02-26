//
//  WorkoutService.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

protocol WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
}

class WorkoutService: WorkoutServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let baseURL: URL

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
         baseURL: URL = APIConfiguration.baseURL) {
        self.networkManager = networkManager
        self.baseURL = baseURL
    }
    
    func fetchWorkouts() async throws -> [Workout] {
        do {
            let workouts: Workouts = try await networkManager.performRequest(url: baseURL, method: .GET, body: nil)
            return workouts.workouts
        } catch let error as NetworkError {
            throw error
        } catch {
            throw error
        }
    }
}
