//
//  WorkoutHistoryView.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel = WorkoutHistoryViewModel()
    @State var workouts: [Workout] = []
    @State var selectedActivity: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredWorkouts) { workout in
                        WorkoutCardView(workout: workout)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.getWorkouts()
            }
            .overlay {
                if viewModel.workouts.isEmpty {
                    Text("No Workouts Found")
                        .font(.largeTitle)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
            .task {
                await viewModel.getWorkouts()
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.5), Color.gray.opacity(0.2), Color.yellow.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all))
    }
    
    var filteredWorkouts: [Workout] {
        if let activity = selectedActivity {
            return viewModel.workouts.filter { $0.activity == activity }
        } else {
            return viewModel.workouts
        }
    }
}

#Preview {
    WorkoutHistoryView()
}
