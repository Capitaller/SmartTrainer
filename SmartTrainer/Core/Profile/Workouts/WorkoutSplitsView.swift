//
//  WorkoutSplitsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 14.10.2024.
//

import SwiftUI

struct WorkoutSplitsView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    
    var body: some View {
        VStack {
            if healthViewModel.workoutSplits.isEmpty {
                Text("No workout splits available.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(10)
            } else {
                Text("Generated Workout Splits")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(10)
                ForEach(healthViewModel.workoutSplits) { split in
                    VStack(alignment: .leading, spacing: 10) {
                        // Block for each workout split
                        Text("Split No: \(split.id)")
                            .font(.headline)
                        
                        Text("Distance: \(split.distance, specifier: "%.2f")")
                        Text("Split Speed: \(String(format: "%.2f", split.splitspeed))")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                }
            }
        }
        .padding()
    }
}



//#Preview {
//    WorkoutSplitsView()
//}
