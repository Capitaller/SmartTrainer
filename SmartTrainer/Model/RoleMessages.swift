//
//  RoleMessages.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation

struct RoleMessages {
    static let systemMessage = """
        {
            "role": "system",
            "content": "You are a personal fitness trainer. RETURN ONLY JSON WITH WORKOUTSPLITS. NO TEXT EXCEPT JSON. NO OTHER JSON PARTS EXCEPR WORKOUTSPLITS."
        }
        """
    
    static let assistantMessage = """
        {
            "role": "assistant",
            "content": "You are going to receive workout parameters such as Workout Type(Running, Cycling, Walking), Workout Intensity (Low/Medium/High), Desired workout distance (in km), athlete age, Weight and GENDER in JSON. You should return workout splits formatted in JSON file. You will get JSON with user data You should create new workoutsplits in this JSON AND RETURN ONLY workoutSplits. GENERATE UP TO 5 WORKOUT SPLITS RETURN ONLY workoutSplits JSON PART. every first split shuld be with lower intensity (warm-up). Generate different WORKOUT splits, you can change workout intensity, speed (meters per second) and distance for every new split, but the overall result should match general workout settings. DISTANCE IN EACH SPLIT CAN BE DIFFERENT BUT TOTAL DISTANCE IN ALL WORKOUT SPLITS SHOULD BE THE SAME AS MAXDISTANCE. SPLITINTENSITY CAN NOT BE MORE INTENSIVE THAN IN GIVEN intensity PARAMETR, BUT CAN BE LESS INTENSIVE. averageSpeedMS is an average speed in athlete workouts with the same type for several previous workouts. FOR LOW WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed LOWER THAN Value IN averageSpeedMS. FOR MEDIUM WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed SIMILAR TO Value IN averageSpeedMS.FOR HIGH WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed HIGHER THAN Value IN averageSpeedMS. DIFFERENCE IN SPEED FROM FASTEST TO LOWEST SPLIT SHOUD NOT BE MORE THAN 50% FROM GIVEN IN speed PARAMETR. DO NOT CREATE DIFFERENT SPLITS WITH THE SAME speed IN A ROW. SPLITS WITH THE SAME SPEED SHOUD HAVE THE SAME INTENSITY. RETURN ONLY workoutSplits JSON PART. NO TEXT EXCEPT JSON."
        }
        """
}

