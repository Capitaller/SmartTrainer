//
//  MainView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 29.09.2024.
//
import SwiftUI

struct WorkoutSettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var healthViewModel = HealthViewModel() // Health ViewModel
    @State private var selectedIntensity: IntensityLevel = .medium
    @State private var selectedWorkoutType: WorkoutType = .run
    @State private var workoutDistance: Double = 5.0
    @State private var showSummary: Bool = false // State to control showing the summary
    @State private var showSplits: Bool = false // State to control showing splits page
    
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                ScrollView {
                    VStack {
                        Spacer().frame(height: 20)
                        
                        Text("Workout Settings")
                            .font(.system(size: 40))
                            .foregroundColor(Color(.darkGray))
                            .padding(10)
                        
                        Text("Select workout type, intensity, and distance")
                            .font(.system(size: 16))
                            .foregroundColor(Color(.darkGray))
                            .padding(10)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        // Workout Type Selection
                        workoutTypeSelection
                        
                        Spacer().frame(height: 30)
                        
                        // Workout Intensity Selection
                        workoutIntensitySelection
                        
                        Spacer().frame(height: 30)
                        
                        // Workout Distance Control
                        workoutDistanceControl
                        
                        Spacer().frame(height: 10)
                        
                        // Suggest workout button
                        Button(action: {
                            healthViewModel.requestHealthKitAuthorization()
                            healthViewModel.RequestWorkout(
                                distance: workoutDistance,
                                intensity: selectedIntensity,
                                workoutType: selectedWorkoutType,
                                athleteID: user.id
                            )
                            withAnimation {
                                showSummary = true
                            }
                        }) {
                            Text("Suggest workout")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        
                        // Show Workout Summary if workout is suggested and splits are available
                        if showSummary && !healthViewModel.workoutSplits.isEmpty {
                            WorkoutSummaryView(
                                workoutType: selectedWorkoutType,
                                distance: workoutDistance,
                                intensity: selectedIntensity,
                                onSplitsButtonPressed: {
                                    withAnimation {
                                        showSplits = true // Trigger the navigation to splits
                                    }
                                }
                            )
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        
                        // NavigationLink to splits page
                        NavigationLink(destination: WorkoutSplitsView(healthViewModel: healthViewModel, workoutType: selectedWorkoutType,distance: workoutDistance,intensity: selectedIntensity), isActive: $showSplits) {
                            EmptyView()
                        }
                    }
                    .navigationBarTitle("Workout Planner", displayMode: .inline)
                    .navigationBarHidden(true)
                }
            }
        }
    }
    
    // Workout Type Selection View
    var workoutTypeSelection: some View {
        HStack {
            Button(action: {
                selectedWorkoutType = .bike
                showSummary = false // Hide summary when workout type changes
            }) {
                Text("Bike")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedWorkoutType == .bike ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedWorkoutType == .bike ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                selectedWorkoutType = .run
                showSummary = false // Hide summary when workout type changes
            }) {
                Text("Run")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedWorkoutType == .run ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedWorkoutType == .run ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                selectedWorkoutType = .walk
                showSummary = false // Hide summary when workout type changes
            }) {
                Text("Walk")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedWorkoutType == .walk ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedWorkoutType == .walk ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 40)
    }
    
    // Workout Intensity Selection View
    var workoutIntensitySelection: some View {
        HStack {
            Button(action: {
                selectedIntensity = .low
                showSummary = false // Hide summary when intensity changes
            }) {
                Text("Low")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedIntensity == .low ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedIntensity == .low ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                selectedIntensity = .medium
                showSummary = false // Hide summary when intensity changes
            }) {
                Text("Medium")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedIntensity == .medium ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedIntensity == .medium ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                selectedIntensity = .high
                showSummary = false // Hide summary when intensity changes
            }) {
                Text("High")
                    .fontWeight(.semibold)
                    .foregroundColor(selectedIntensity == .high ? .white : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedIntensity == .high ? Color.blue : Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 40)
    }
    
    // Workout Distance Control View
    var workoutDistanceControl: some View {
        VStack {
            HStack(spacing: 10) {
                Button(action: {
                    if workoutDistance > 1 {
                        workoutDistance -= 0.5
                        showSummary = false // Hide summary when distance changes
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .frame(width: 60)
                
                Text(String(format: "%.1f", workoutDistance))
                    .font(.system(size: 32, weight: .bold))
                    .frame(width: 160, alignment: .center)
                    .foregroundColor(Color(.darkGray))
                
                Button(action: {
                    workoutDistance += 0.5
                    showSummary = false // Hide summary when distance changes
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .frame(width: 60)
            }
            
            Text("KM")
                .font(.system(size: 16))
                .foregroundColor(Color(.darkGray))
        }
    }
}
