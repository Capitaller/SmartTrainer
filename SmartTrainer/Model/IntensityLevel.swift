//
//  IntensityLevel.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 05.10.2024.
//

import Foundation

enum IntensityLevel: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}
