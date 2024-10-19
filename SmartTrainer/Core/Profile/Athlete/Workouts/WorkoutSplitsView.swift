//
//  WorkoutSplitsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 14.10.2024.
//
import SwiftUI

struct WorkoutSplitsView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    var workoutType: WorkoutType
    var distance: Double
    var intensity: IntensityLevel
    @StateObject var workoutViewModel = WorkoutViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var editMode: [Int: Bool] = [:] // A dictionary to track which split is being edited
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var showingAlert = false // State to control alert visibility

    var body: some View {
        VStack {
            if healthViewModel.workoutSplits.isEmpty {
                Text("No workout splits available.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(10)
            } else {
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
            
            HStack {
                // Cancel Button
                Button(action: {
                    healthViewModel.workoutSplits.removeAll() // Clear all splits
                    presentationMode.wrappedValue.dismiss() // Go back to the previous page
                }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Cancel")
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }

                Spacer()

                // Confirm Button
                Button(action: {
                    Task {
                        do {
                            let workoutSplits = healthViewModel.workoutSplits  // Assume you pass workout splits here
                            
                            // Create a new workout in Firestore using workoutId from splits
                            try await workoutViewModel.createWorkout(userId: viewModel.currentUser?.id ?? "", workoutSplits: workoutSplits, workoutType: workoutType,distance: distance,intensity: intensity)
                            
                            // Show the success alert and notify the user
                            showingAlert = true
                            
                        } catch {
                            // Handle error
                            print("Failed to create workout and splits: \(error)")
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Confirm")
                    }
                    .foregroundColor(.green)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Done!"),
                message: Text("Your workout has been successfully sent for approval."),
                dismissButton: .default(Text("OK")) {
                    // Show tab bar again when dismissing the view
                    presentationMode.wrappedValue.dismiss()
                    // Make the tab bar visible again here after dismissal
                    UITabBar.appearance().isHidden = false
                }
            )
        }
        .onAppear {
            // Initially hide the tab bar when this view appears
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            // Ensure the tab bar reappears when the view disappears
            UITabBar.appearance().isHidden = false
        }
    }

    // Custom Decimal Formatter
    private func decimalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
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
