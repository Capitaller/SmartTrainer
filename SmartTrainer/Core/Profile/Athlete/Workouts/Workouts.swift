//
//  Workouts.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 19.10.2024.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutsView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts, id: \.id) { workout in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(workout.date, style: .date)
                                .font(.headline)
                            Spacer()
                            Text(workout.approvingState)
                                .font(.subheadline)
                                .foregroundColor(colorForApprovalState(workout.approvingState))
                        }
                        HStack {
                            Text(workout.workoutType)
                                .font(.subheadline)
                            Spacer()
                            Text("\(workout.distance, specifier: "%.2f") km")
                                .font(.subheadline)
                            Spacer()
                            Text(workout.intensity)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Workouts")
            .onAppear {
                loadWorkouts()
            }
        }
    }
    
    private func loadWorkouts() {
        guard let userId = authViewModel.currentUser?.id else { return }
        Task {
            do {
                try await viewModel.fetchWorkouts(for: userId)
            } catch {
                print("Error fetching workouts: \(error.localizedDescription)")
            }
        }
    }
    func colorForApprovalState(_ state: String) -> Color {
        switch state {
        case "Approved":
            return .green
        case "Pending Approval":
            return .yellow
        default: // Covers any other states like "Declined"
            return .red
        }
    }
}
