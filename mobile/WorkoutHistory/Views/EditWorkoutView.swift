//
//  EditWorkout.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 3/1/25.
//

import SwiftUI
import PhotosUI

struct EditWorkoutView: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @Environment(\.dismiss) var dismiss

    let workout: Workout
    @State private var activity: String
    @State private var duration: String
    @State private var caloriesBurned: String
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    init(workout: Workout) {
        self.workout = workout
        _activity = State(initialValue: workout.activity)
        _duration = State(initialValue: "\(workout.duration)")
        _caloriesBurned = State(initialValue: "\(workout.caloriesBurned)")
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Activity", text: $activity)
                CustomTextField(placeholder: "Duration (mins)", text: $duration, keyboardType: .numberPad)
                CustomTextField(placeholder: "Calories Burned", text: $caloriesBurned, keyboardType: .numberPad)

                PhotosPicker(selection: $selectedImage, matching: .images) {
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Text("Select New Workout Image")
                            .foregroundColor(.purple)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .onChange(of: selectedImage) { newItem in
                    Task {
                        if let newItem {
                            do {
                                if let imageData = try await newItem.loadTransferable(type: Data.self) {
                                    self.imageData = imageData
                                }
                            } catch {
                                print("Error loading image: \(error.localizedDescription)")
                            }
                        }
                    }
                }

                Button("Save Changes") {
                    Task {
                        await editWorkout()
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()

                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    private func editWorkout() async {
        do {
            guard let durationInt = Int(duration), let caloriesInt = Int(caloriesBurned) else { return }

            try await workoutVM.editWorkout(
                workoutId: workout.id,
                activity: activity,
                duration: durationInt,
                caloriesBurned: caloriesInt,
                imageData: imageData
            )

            await MainActor.run {
                workoutVM.updateWorkoutLocally(Workout(
                    id: workout.id,
                    activity: activity,
                    duration: durationInt,
                    caloriesBurned: caloriesInt,
                    imageUrl: imageData != nil ? nil : workout.imageUrl,
                    createdAt: workout.createdAt
                ))

                Task {
                    await workoutVM.fetchWorkouts()
                }

                dismiss()
            }
        } catch {
            print("Failed to edit workout: \(error.localizedDescription)")
        }
    }
}
