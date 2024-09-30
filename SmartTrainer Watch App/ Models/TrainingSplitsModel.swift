//
//  TrainingSplitsModel.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 26.04.2024.
//

import Foundation

  
class TrainingSplits
{
      
    var id: Int = 0
    var workoutId: Int = 0
    var time: String = ""
    var heartRate: Double = 0
    var activeEnergy: Double = 0
    var distance: Double = 0

      
    init(id:Int, workoutId:Int, time:String, heartRate: Double, activeEnergy: Double, distance: Double)
    {
        self.id = id
        self.workoutId = workoutId
        self.time = time
        self.heartRate = heartRate
        self.activeEnergy = activeEnergy
        self.distance = distance
    }
}
