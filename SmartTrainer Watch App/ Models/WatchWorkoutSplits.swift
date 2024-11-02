//
//  WatchWorkoutSplits.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 27.10.2024.
//

import Foundation

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
