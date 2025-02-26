//
//  WorkoutCard.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import SwiftUI
import Foundation

struct WorkoutCardView: View {
    let workout: Workout

    @State private var image: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(15)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                    .overlay(ProgressView())
            }
            
            VStack(alignment: .leading) {
                Text(workout.activity)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(workout.activity)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
        }
        .task(id: workout.imageUrl) {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard image == nil, let url = URL(string: workout.imageUrl ?? "") else { return }
        do {
            image = try await ImageLoader.shared.loadImage(from: url)
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
