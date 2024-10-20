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

struct WorkoutSplit: Identifiable, Codable {
    var id: Int
    var workoutId: Int
    var athleteID: String
    var distance: Double
    var splitspeed: Double
    var splitIntensity: String
    var splitworkouttype: String
    var comment: String
}

// Workout data model
struct Workout: Identifiable, Codable {
    var id: Int
    var athleteID: String
    var date: String
    var type: String
    var intensity: String
    var MAXdistance: Double
    var approvingStatus: Bool
    var TrainerComment: String
    var workoutSplits: [WorkoutSplit]
}
struct WorkoutF: Identifiable, Codable {
    var id: String
    var date: Date
    var approvingState: String
    var workoutType: String
    var distance: Double
    var intensity: String
    var athleteName: String
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
