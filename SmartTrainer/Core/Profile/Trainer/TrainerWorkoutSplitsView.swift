//
//  TrainerWorkoutSplitsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 20.10.2024.
//

import SwiftUI
import FirebaseFirestore


struct TrainerWorkoutSplitsView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var workoutSplits: [WorkoutSplit] = []
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    var workoutId: String
    var onStatusUpdated: () -> Void // Closure for updating status
    @State private var editMode: [Int: Bool] = [:] // A dictionary to track which split is being edited
    @State private var editedSplits: [Int] = [] // To track edited splits
    
    var body: some View {
        ScrollView {
            VStack {
                if workoutSplits.isEmpty {
                    Text("No workout splits available.")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.darkGray))
                        .padding(10)
                } else {
                    ForEach(workoutSplits) { split in
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
                                
                                HStack {
                                    Text("Comment: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    TextField("Comment", text: Binding(
                                        get: { split.comment },
                                        set: { newValue in
                                            updateSplitComment(for: split.id, newValue: newValue)
                                        }))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: .infinity)
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
                                
                                HStack {
                                    Text("Comment: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("\(String(split.comment))")
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
                    // Approve Button
                    Button(action: {
                        Task {
                            do {
                                // Update all edited splits first
                                try await updateAllEditedSplits()
                                // Update the total distance in the workout
                                let totalDistance = workoutSplits.reduce(0) { $0 + $1.distance }
                                try await workoutViewModel.updateWorkoutDistance(workoutId: workoutId, distance: totalDistance)
                                // Approve the workout
                                try await workoutViewModel.updateWorkoutApprovalStatus(workoutId: workoutId, status: "Approved")
                                showingAlert = true
                                onStatusUpdated() // Trigger the update on status change
                            } catch {
                                print("Error approving workout: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Approve")
                        }
                        .foregroundColor(.green)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Decline Button
                    Button(action: {
                        Task {
                            do {
                                // Update all edited splits first
                                try await updateAllEditedSplits()
                                // Decline the workout
                                try await workoutViewModel.updateWorkoutApprovalStatus(workoutId: workoutId, status: "Declined")
                                showingAlert = true
                                onStatusUpdated() // Trigger the update on status change
                            } catch {
                                print("Error declining workout: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Status Updated"),
                message: Text("The workout has been successfully updated."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
            )
        }
        .onAppear {
            loadWorkoutSplits()
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            // Ensure the tab bar reappears when the view disappears
            UITabBar.appearance().isHidden = false
        }
    }
    
    private func loadWorkoutSplits() {
        Task {
            do {
                workoutSplits = try await workoutViewModel.fetchWorkoutSplits(for: workoutId)
            } catch {
                print("Failed to fetch workout splits: \(error)")
            }
        }
    }
    
    // Function to update all edited splits when Approve or Decline button is pressed
    private func updateAllEditedSplits() async {
        for splitId in editedSplits {
            if let split = workoutSplits.first(where: { $0.id == splitId }) {
                do {
                    try await workoutViewModel.updateWorkoutSplit(workoutId: workoutId, split: split)
                } catch {
                    print("Error updating split \(splitId): \(error.localizedDescription)")
                }
            }
        }
        // Clear the edited splits after updating
        editedSplits.removeAll()
    }
    
    
    // Functions to update the workout split model and Firestore
    private func updateSplitDistance(for id: Int, newValue: Double) {
        if let index = workoutSplits.firstIndex(where: { $0.id == id }) {
            workoutSplits[index].distance = newValue
            // Add to edited splits if it's not already there
            if !editedSplits.contains(workoutSplits[index].id) {
                editedSplits.append(workoutSplits[index].id)
            }
        }
    }
    
    private func updateSplitSpeed(for id: Int, newValue: Double) {
        if let index = workoutSplits.firstIndex(where: { $0.id == id }) {
            workoutSplits[index].splitspeed = newValue
            // Add to edited splits if it's not already there
            if !editedSplits.contains(workoutSplits[index].id) {
                editedSplits.append(workoutSplits[index].id)
            }
        }
    }
    
    private func updateSplitComment(for id: Int, newValue: String) {
        if let index = workoutSplits.firstIndex(where: { $0.id == id }) {
            workoutSplits[index].comment = newValue
            // Add to edited splits if it's not already there
            if !editedSplits.contains(workoutSplits[index].id) {
                editedSplits.append(workoutSplits[index].id)
            }
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
}


