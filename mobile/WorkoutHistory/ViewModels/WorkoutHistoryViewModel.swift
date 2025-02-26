//
//  WorkoutHistory.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

@MainActor
class WorkoutHistoryViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var types: [String] {
        ["All"] + Set(workouts.map { $0.activity }).sorted()
    }
    
    private let workoutService: WorkoutServiceProtocol
    
    init(workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.workoutService = workoutService
    }
    
    func getWorkouts() async {
        isLoading = true
        do {
            workouts = try await workoutService.fetchWorkouts()
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unknown error occurred."
        }
        isLoading = false
    }
}
