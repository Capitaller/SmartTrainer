//
//  WatchConnectivity.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 27.10.2024.
//

import Foundation
import WatchConnectivity


class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    var dbManager = DBManager()
    
    override init() {
        self.session = WCSession.default
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Received message:", message)
        guard let workoutSplit = parseWorkoutSplit(from: message) else {
            print("Failed to parse workout split.")
            return
        }
        
        // Clear existing workout splits and add the new one
        let db = DBManager()
        
        if workoutSplit.id == 1 {
            db.createWorkoutSplitsTable()
            
            db.deleteAllWorkoutSplits()
        }// Clear previous data
        db.insertWorkoutSplit(workoutSplit: workoutSplit)  // Insert new data
    }
    
    private func parseWorkoutSplit(from message: [String: Any]) -> WorkoutSplit? {
        guard let id = message["id"] as? Int,
              let workoutId = message["workoutId"] as? Int,
              let athleteID = message["athleteID"] as? String,
              let distance = message["distance"] as? Double,
              let splitspeed = message["splitspeed"] as? Double,
              let splitIntensity = message["splitIntensity"] as? String,
              let splitworkouttype = message["splitworkouttype"] as? String,
              let comment = message["comment"] as? String else {
            return nil
        }
        return WorkoutSplit(id: id, workoutId: workoutId, athleteID: athleteID, distance: distance, splitspeed: splitspeed, splitIntensity: splitIntensity, splitworkouttype: splitworkouttype, comment: comment)
    }
}

