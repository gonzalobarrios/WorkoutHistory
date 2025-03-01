//
//  WorkoutHistoryApp.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import SwiftUI

@main
struct WorkoutHistoryApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            let workoutVM = WorkoutViewModel(workoutService: WorkoutService())

            if authVM.isAuthenticated {
                WorkoutListView()
                    .environmentObject(authVM)
                    .environmentObject(workoutVM)
            } else {
                LoginView()
                    .environmentObject(authVM)
            }
        }
    }
}
