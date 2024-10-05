//
//  MainView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 29.09.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedIntensity: IntensityLevel = .medium
    @State private var selectedWorkoutType: WorkoutType = .run // Add a state variable for the workout type
    @State private var workoutDistance: Double = 5.0
    @State private var workoutCalories: Int = 300
    @State private var verticalOffset: CGFloat = 0 // State variable for vertical offset

    var body: some View {
        ZStack {
            // Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                
                Spacer() // This Spacer centers the content vertically
                Text("Workout Settings")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.darkGray))
                    .padding(20)
                
                
                // Workout Type Selection
                VStack{
                    Text("Workout Type")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.darkGray))
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
                }
                .padding(.horizontal, 40)

                Spacer().frame(height: 30)
                // Workout Intensity Selection
                VStack{
                    Text("Intensity")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.darkGray))
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
//                    Text("Workout Intensity")
//                        .font(.system(size: 16))
//                        .foregroundColor(Color(.darkGray))
                }
                .padding(.horizontal, 40)

                Spacer().frame(height: 20)

                // Workout Distance Control
                VStack {
                    Text("Distance")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.darkGray))
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

                Spacer().frame(height: 5)

                // Suggest workout button
                Button(action: {
                    withAnimation {
                        verticalOffset = -UIScreen.main.bounds.height / 4 + 10 // Move the view up to a desired position
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

                Spacer()
            }
            .offset(y: verticalOffset) // Apply vertical offset to the VStack
            .animation(.easeInOut, value: verticalOffset) // Animation for smooth transition
        }
    }
}

#Preview {
    MainView()
}
