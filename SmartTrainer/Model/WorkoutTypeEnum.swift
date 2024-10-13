//
//  Untitled.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 05.10.2024.
//

import Foundation
import HealthKit 

enum WorkoutType: String, Codable, CaseIterable {
    case bike = "Bike"
    case run = "Run"
    case walk = "Walk"
    
    var displayName: String {
        switch self {
        case .bike:
            return "Bike"
        case .run:
            return "Run"
        case .walk:
            return "Walk"
        }
    }
    var hkWorkoutActivityType: HKWorkoutActivityType {
            switch self {
            case .bike:
                return .cycling
            case .run:
                return .running
            case .walk:
                return .walking
            }
        }
}
