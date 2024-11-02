//
//  WorkoutSummaryView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 14.10.2024.
//

import SwiftUI

struct WorkoutSummaryView: View {
    var workoutType: WorkoutType
    var distance: Double
    var intensity: IntensityLevel
    var onSplitsButtonPressed: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Workout Summary")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("Type: \(workoutType.rawValue.capitalized)")
            Text("Distance: \(String(format: "%.1f", distance)) KM")
            Text("Intensity: \(intensity.rawValue.capitalized)")
            
            Button(action: {
                onSplitsButtonPressed()
            }) {
                Text("See Splits")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 40)
    }
}

#Preview {
    WorkoutSummaryView(workoutType: .run, distance: 5.0, intensity: .medium, onSplitsButtonPressed: {})
}

