//
//  SwiftUIView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 20.10.2024.
//

import SwiftUI

struct AthleteWorkoutSplitsView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    var workoutId: String
    var approvingStatus: String
    @State private var workoutSplits: [WorkoutSplit] = []

    var body: some View {
        VStack {
            if workoutSplits.isEmpty {
                Text("No workout splits available.")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(10)
            } else {
                List(workoutSplits) { split in
                    VStack(alignment: .leading) {
                        Text("Split No: \(split.id)")
                            .font(.headline)
                        Text("Distance: \(split.distance, specifier: "%.2f") KM")
                        Text("Split Speed: \(String(format: "%.2f", split.splitspeed)) m/s")
                        Text("Comment: \(split.comment)")
                    }
                    .padding()
                }
            }
            if approvingStatus == WorkoutApprovalStatus.approved.rawValue {
                Button(action: {
                    transferToWatch()
                }) {
                    HStack {
                        Image(systemName: "applewatch")
                        Text("Transfer to Watch")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.top)
            }
            
        }
        .navigationTitle("Workout Splits")
        .onAppear {
            // Initially hide the tab bar when this view appears
            UITabBar.appearance().isHidden = true
            loadWorkoutSplits()
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

    private func transferToWatch() {
        // Implement the logic to transfer splits to the watch
        print("Transfer to Watch triggered for workout ID: \(workoutId)")
    }
}

