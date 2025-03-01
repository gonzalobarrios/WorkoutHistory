//
//  WorkoutViewModel.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

@MainActor
class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var errorMessage: String?

    private let workoutService: WorkoutServiceProtocol

    init(workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.workoutService = workoutService
    }

    func fetchWorkouts() async {
        do {
            let fetchedWorkouts = try await workoutService.fetchWorkouts()
            self.workouts = fetchedWorkouts
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func logWorkout(activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async {
        do {
            let message = try await workoutService.logWorkout(activity: activity, duration: duration, caloriesBurned: caloriesBurned, imageData: imageData)
            await fetchWorkouts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWorkout(workoutId: Int) async {
        do {
            let message = try await workoutService.deleteWorkout(workoutId: workoutId)
            print("Workout Deleted: \(message)")
            await fetchWorkouts()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to delete workout: \(error.localizedDescription)")
        }
    }

    func editWorkout(workoutId: Int, activity: String, duration: Int, caloriesBurned: Int, imageData: Data?) async {
        do {
            try await workoutService.editWorkout(workoutId: workoutId, activity: activity, duration: duration, caloriesBurned: caloriesBurned, imageData: imageData)
            await fetchWorkouts()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func updateWorkoutLocally(_ updatedWorkout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == updatedWorkout.id }) {
            workouts[index] = updatedWorkout
        }
    }
}
