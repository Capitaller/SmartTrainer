//
//  UserTypeEnum.swift
//  MastersDiplomaFitnessApp
//
//  Created by Anton Shcherbakov on 28.09.2024.
//

import Foundation

enum UserType: String, Codable, CaseIterable {
    case athlete = "Athlete"
    case trainer = "Trainer"
    
    var displayName: String {
        switch self {
        case .athlete:
            return  "Athlete"
        case .trainer:
            return "Trainer"
        }
    }
}
