//
//  TrainerWorkoutsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 20.10.2024.
//

import SwiftUI

struct TrainerWorkoutsView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var athleteViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts, id: \.id) { workout in
                    NavigationLink(
                        destination: TrainerWorkoutSplitsView(workoutId: workout.id, onStatusUpdated: {
                            // Reload workouts when status is updated
                            loadAthletesAndWorkouts()
                        })
                    ) {
                        VStack(alignment: .leading) {
                            Text(workout.athleteName)
                                .font(.headline)
                                .padding(.bottom, 2)

                            HStack {
                                Text(workout.date, style: .date)
                                    .font(.subheadline)
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
            }
            .navigationTitle("Workouts for Your Athletes")
            .onAppear {
                loadAthletesAndWorkouts()
            }
        }
    }

    private func loadAthletesAndWorkouts() {
        guard let trainerId = authViewModel.currentUser?.id else { return }
        Task {
            do {
                // Fetch athletes first
                await athleteViewModel.fetchAthletes()

                // Clear existing workouts before fetching new ones
                viewModel.workouts.removeAll()

                // Fetch workouts for each athlete
                try await viewModel.fetchWorkoutsForAthletes(athletes: athleteViewModel.athletes)
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
        default:
            return .red
        }
    }
}


