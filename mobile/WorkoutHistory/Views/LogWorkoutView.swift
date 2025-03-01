//
//  LogWorkoutView.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import SwiftUI
import PhotosUI

struct LogWorkoutView: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State private var activity = ""
    @State private var duration = ""
    @State private var caloriesBurned = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    @Environment(\.dismiss) var dismiss

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
                        Text("Select Workout Image")
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
                                if let imageData = try await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: imageData),
                                   let resizedImage = uiImage.resized(toWidth: 1024),
                                   let compressedData = resizedImage.resized(to: 500) {
                                    self.imageData = compressedData
                                }
                            } catch {
                                print("Error loading and compressing image: \(error.localizedDescription)")
                            }
                        }
                    }
                }

                Button("Save Workout") {
                    Task {
                        guard let durationInt = Int(duration), let caloriesInt = Int(caloriesBurned) else {
                            print("Invalid input")
                            return
                        }

                        do {
                            await workoutVM.logWorkout(
                                activity: activity,
                                duration: durationInt,
                                caloriesBurned: caloriesInt,
                                imageData: imageData
                            )
                            print("Workout Logged Successfully")
                            dismiss()
                        }
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Log Workout")
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

