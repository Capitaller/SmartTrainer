//
//  WorkoutModel.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 25.04.2024.
//

import Foundation
  
class Workout
{
      
    var date: String = ""
    var id: Int = 0
    var type: String = ""
      
    init(id:Int, date:String, type:String)
    {
        self.id = id
        self.date = date
        self.type = type
    }
}
