//
//  RoleMessages.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation

struct RoleMessages {
    static let systemMessage = """
    You are a personal fitness trainer. You are going to receive workout parameters such as Workout Type (Running, Cycling, Walking), Workout Intensity (Low/Medium/High), Desired workout distance (in km), athlete age, VO2Max, and Weight in JSON. You should return workout splits formatted in JSON file. RETURN ONLY JSON. NO TEXT EXCEPT JSON. You will get JSON with user data. You should add new training splits in this JSON as in the example. GENERATE UP TO 5 TRAINING SPLITS. RETURN ONLY \"workoutSplits\" JSON PART:
    """
    
    static let assistantMessage = """
    Generate different training splits, you can change workout intensity, time in seconds and distance for every new split, but the overall result should match general workout settings. RETURN ONLY \"workoutSplits\" JSON. TOTAL DISTANCE IN ALL TRAINING SPLITS SHOULD BE THE SAME AS MAXDISTANCE
    """
}

