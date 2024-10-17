//
//  WorkoutSplitsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 14.10.2024.
//

import SwiftUI

struct WorkoutSplitsView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    @State private var editMode: [Int: Bool] = [:] // A dictionary to track which split is being edited

    var body: some View {
        VStack {
            if healthViewModel.workoutSplits.isEmpty {
                Text("No workout splits available.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(10)
            } else {
//                Text("Generated Workout Splits")
//                    .font(.system(size: 20))
//                    .foregroundColor(Color(.darkGray))
//                    .padding(10)
                
                ForEach(healthViewModel.workoutSplits) { split in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Split No: \(split.id)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Button(action: {
                                editMode[split.id] = !(editMode[split.id] ?? false) // Toggle edit mode for this split
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if editMode[split.id] ?? false {
                            // Editable fields when in edit mode
                            HStack {
                                Text("Distance: ")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                TextField("Distance", value: Binding(
                                    get: { split.distance },
                                    set: { newValue in
                                        updateSplitDistance(for: split.id, newValue: newValue)
                                    }), formatter: decimalFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 130)
                            }
                            
                            HStack {
                                Text("Split Speed: ")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                TextField("Speed", value: Binding(
                                    get: { split.splitspeed },
                                    set: { newValue in
                                        updateSplitSpeed(for: split.id, newValue: newValue)
                                    }), formatter: decimalFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 130)
                            }
                        } else {
                            // Regular display when not in edit mode
                            HStack {
                                Text("Distance: ")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("\(split.distance, specifier: "%.2f") KM")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.darkGray))
                            }
                            
                            HStack {
                                Text("Split Speed: ")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("\(String(format: "%.2f", split.splitspeed)) m/s")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.darkGray))
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    // Custom Decimal Formatter
        private func decimalFormatter() -> NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2 // Maximum of 2 decimal places
            formatter.minimumFractionDigits = 0 // Minimum of 0 to avoid unnecessary decimals
            formatter.alwaysShowsDecimalSeparator = false
            return formatter
        }
    // Functions to update the workout split model
    private func updateSplitDistance(for id: Int, newValue: Double) {
        if let index = healthViewModel.workoutSplits.firstIndex(where: { $0.id == id }) {
            healthViewModel.workoutSplits[index].distance = newValue
        }
    }
    
    private func updateSplitSpeed(for id: Int, newValue: Double) {
        if let index = healthViewModel.workoutSplits.firstIndex(where: { $0.id == id }) {
            healthViewModel.workoutSplits[index].splitspeed = newValue
        }
    }
}




//#Preview {
//    WorkoutSplitsView()
//}
