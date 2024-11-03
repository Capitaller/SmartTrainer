//
//  WatchConnectivity.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 27.10.2024.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated. Activating a new session.")
        session.activate() // Reactivate the session if needed
    }
    
    func sendWorkoutSplit(_ split: WorkoutSplit) {
        print(session.isPaired)
        print(session.isWatchAppInstalled)
        print(session.activationState.rawValue)
        print(session.isReachable)
        if session.isReachable {
            let data: [String: Any] = [
                "id": split.id,
                "workoutId": split.workoutId,
                "athleteID": split.athleteID,
                "distance": split.distance,
                "splitspeed": split.splitspeed,
                "splitIntensity": split.splitIntensity,
                "splitworkouttype": split.splitworkouttype,
                "comment": split.comment
            ]
            session.sendMessage(data, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable.")
        }
    }
}
