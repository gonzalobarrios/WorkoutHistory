//
//  WorkoutListView.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var workoutVM: WorkoutViewModel

    @State private var showLogWorkoutView = false
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    if isLoading {
                        ProgressView("Loading Workouts...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    } else if workoutVM.workouts.isEmpty {
                        Text("No workouts logged yet.")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                    } else {
                        List {
                            ForEach(workoutVM.workouts, id: \.id) { workout in
                                WorkoutCardView(workout: workout)
                                    .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showLogWorkoutView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .frame(width: 70, height: 70)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 6)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                        .sheet(isPresented: $showLogWorkoutView) {
                            LogWorkoutView()
                                .environmentObject(workoutVM)
                        }
                    }
                }
            }
            .navigationTitle("Your Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your Workouts")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authVM.logout()
                    }) {
                        Image(systemName: "power")
                            .foregroundColor(.red)
                    }
                }
            }
            .task {
                isLoading = true
                await workoutVM.fetchWorkouts()
                isLoading = false
            }
        }
    }
}
