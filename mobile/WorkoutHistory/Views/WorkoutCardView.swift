//
//  WorkoutCard.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State private var uiImage: UIImage?
    @State private var showEditWorkoutView = false

    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = workout.imageUrl, let url = URL(string: imageUrl) {
                ZStack {
                    if let uiImage = uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                            .clipped()
                    } else {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                            .onAppear {
                                Task {
                                    do {
                                        self.uiImage = try await ImageLoader.shared.loadImage(from: url)
                                    } catch {
                                        print("Failed to load image: \(error)")
                                    }
                                }
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 250)
            }

            VStack(spacing: 8) {
                HStack {
                    WorkoutInfoView(title: "Activity", value: workout.activity)
                    Divider()
                    WorkoutInfoView(title: "Duration", value: "\(workout.duration) min")
                    Divider()
                    WorkoutInfoView(title: "Kcal burned", value: "\(workout.caloriesBurned) Cal")
                }
                .frame(maxWidth: .infinity)

                HStack {
                    Button(action: {
                        showEditWorkoutView = true
                        print("Edit Button Tapped for Workout ID: \(workout.id)")
                    }) {
                        Text("Edit")
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 20)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded { _ in })
                    .sheet(isPresented: $showEditWorkoutView) {
                        EditWorkoutView(workout: workout)
                            .environmentObject(workoutVM)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Button(action: {
                        Task {
                            print("Delete Button Tapped for Workout ID: \(workout.id)")
                            await deleteWorkout()
                        }
                    }) {
                        Text("Delete")
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 20)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded { _ in })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color.white)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }

    private func deleteWorkout() async {
        do {
            await workoutVM.deleteWorkout(workoutId: workout.id)
            await workoutVM.fetchWorkouts()
        }
    }
}

struct WorkoutInfoView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}
