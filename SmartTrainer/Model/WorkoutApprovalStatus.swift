//
//  WorkoutApprovalStatus.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 19.10.2024.
//

import Foundation


enum WorkoutApprovalStatus: String, Codable, CaseIterable {
    case pendingApproval = "Pending Approval"
    case approved = "Approved"
    case declined = "Declined"
    
    var displayName: String {
        switch self {
        case .pendingApproval:
            return  "Pending Approval"
        case .approved:
            return "Approved"
        case .declined:
            return "Declined"
        }
    }
}
