//
//  WorkoutRequest.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation

// HealthData model for user health data
struct HealthData: Codable {
    var id: Int
    var athleteID: String
    var age: Int
    var weight: Double
    var sex: String
}

// VO2Max data model
struct VO2MaxData: Codable {
    var id: Int
    var athleteID: String
    var date: String
    var VO2MAX: Double
}

// Workout splits data model
struct WorkoutSplit: Codable {
    var id: Int
    var workoutId: String
    var athleteID: String
    var distance: String
    var splitTime: String
    var splitIntensity: String
    var comment: String
}

// Workout data model
struct Workout: Codable {
    var id: Int
    var athleteID: String
    var date: String
    var type: String
    var intensity: String
    var MAXdistance: Double
    var approved: Bool
    var TrainerComment: String
    var workoutSplits: [WorkoutSplit]
}

// User data model
struct UserData: Codable {
    var id: Int
    var email: String
    var date: String
    var workouts: [Workout]
}

// API request message data model
struct Message: Codable {
    var role: String
    var content: String
}

// API request body data model
struct APIRequestBody: Codable {
    var messages: [Message]
    var temperature: Double
    var top_p: Double
}
