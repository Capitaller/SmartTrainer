//
//  EnumConstants.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 07.05.2024.
//

import Foundation

enum ConstantsEnum {

    enum settingsNames {
        static let userAge = "UserAge"
        static let userDistance = "UserDistance"
     }
    enum adviceNames {
        static let highHeartRate = "Your heart rate is too high!"
        static let keepMoving = "Keep moving!"
        static let reducePace = "To achieve the goal, it is better to reduce the pace!"
        static let increasePace = "You can pick up the pace a bit!"
     }
    enum info {
        static let info1 = "This app can display advice about your workout and show warnings if your heart rate is too high."
        static let infoWarning = "WARNING!"
        static let info2 = "If you feel unwell, you should stop exercising immediately, regardless of the advice displayed."
     }
    
}
