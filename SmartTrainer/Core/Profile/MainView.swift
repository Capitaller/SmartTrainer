//
//  MainView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 29.09.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var healthViewModel = HealthViewModel() // Health ViewModel
    @State private var selectedIntensity: IntensityLevel = .medium
    @State private var selectedWorkoutType: WorkoutType = .run
    @State private var workoutDistance: Double = 5.0
    @State private var verticalOffset: CGFloat = 0 // State variable for vertical offset
    @State private var showText: Bool = true // New state variable to control text visibility
    @State private var showSummary: Bool = false // State to control showing the summary
    @State private var showSplits: Bool = false // State to control showing splits page

    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                ZStack {
                    VStack {
                        Spacer() // Centering content vertically
                        
                        // Conditionally show the text based on the state variable
                        if showText {
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
                        }
                        
                        // Workout Type Selection
                        workoutTypeSelection
                        
                        Spacer().frame(height: 30)
                        
                        // Workout Intensity Selection
                        workoutIntensitySelection
                        
                        Spacer().frame(height: 30)
                        
                        // Workout Distance Control
                        workoutDistanceControl
                        
                        Spacer().frame(height: 5)
                        
                        // Suggest workout button
                        Button(action: {
                            healthViewModel.requestHealthKitAuthorization()
                            healthViewModel.RequestWorkout( // Access the method directly from healthViewModel
                                distance: workoutDistance,
                                intensity: selectedIntensity,
                                workoutType: selectedWorkoutType,
                                athleteID: user.id
                            )
                            withAnimation {
                                verticalOffset = -UIScreen.main.bounds.height / 4 + 10
                                showText = false
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
                        
                        // Show Summary under the button if workout is suggested
                        if showSummary {
                            WorkoutSummaryView(
                                workoutType: selectedWorkoutType,
                                distance: workoutDistance,
                                intensity: selectedIntensity,
                                onSplitsButtonPressed: {
                                    showSplits = true
                                }
                            )
                            .padding(.bottom, 40)
                        }
                        Spacer()
                    }
                    .offset(y: verticalOffset)
                    .animation(.easeInOut, value: verticalOffset)
                    .navigationBarTitle("Workout Planner", displayMode: .inline)
                    .navigationBarHidden(true)
                    
                    // Navigation to workout splits page
                    NavigationLink(destination: WorkoutSplitsView(healthViewModel: healthViewModel), isActive: $showSplits) {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    // Workout Type Selection View
    var workoutTypeSelection: some View {
        HStack {
            Button(action: {
                selectedWorkoutType = .bike
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

#Preview {
    MainView()
}
