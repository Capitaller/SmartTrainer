//
//  Untitled.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 05.10.2024.
//

import Foundation

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
}
