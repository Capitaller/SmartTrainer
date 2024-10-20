//
//  WorkoutViewModel.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 19.10.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class WorkoutViewModel: ObservableObject {
    @Published var workoutID: String?
    @Published var workouts: [WorkoutF] = []
    
    // Function to create a new workout in Firestore using workoutId from splits
    func createWorkout(userId: String, workoutSplits: [WorkoutSplit], workoutType: WorkoutType, distance: Double, intensity: IntensityLevel) async throws {
        guard let firstSplit = workoutSplits.first else {
            print("No workout splits available")
            return
        }
        
        let workoutIdFromSplit = firstSplit.workoutId // Get the workoutId from the first split
        
        let db = Firestore.firestore()
        
        // Create a new document in the "Workout" collection
        let workoutRef = db.collection("workouts").document()
        
        // Set workout data including the User ID and workout ID
        let workoutData: [String: Any] = [
            "userId": userId,
            "date": Date(),
            "approvingState": WorkoutApprovalStatus.pendingApproval.rawValue,
            "workoutType": workoutType.rawValue,
            "distance": distance,
            "intensity": intensity.rawValue
        ]
        
        do {
            // Save workout data to Firestore
            try await workoutRef.setData(workoutData)
            
            // After saving the workout, add workout splits
            try await createWorkoutSplits(workoutId: workoutRef.documentID, workoutSplits: workoutSplits)
        } catch {
            print("Error creating workout: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Function to create a collection of workout splits related to the workout
    private func createWorkoutSplits(workoutId: String, workoutSplits: [WorkoutSplit]) async throws {
        let db = Firestore.firestore()
        
        // Iterate through the workout splits and add each to Firestore
        for split in workoutSplits {
            let splitRef = db.collection("workouts").document(workoutId).collection("workoutSplits").document(String(split.id))
            
            // Create the split data including workoutId
            var splitData = try Firestore.Encoder().encode(split)
            splitData["workoutId"] = workoutId
            
            do {
                // Save each split to the "workoutSplits" subcollection
                try await splitRef.setData(splitData)
            } catch {
                print("Error creating workout split: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    func fetchWorkouts(for userId: String) async throws {
        let db = Firestore.firestore()
        
        let querySnapshot = try await db.collection("workouts").whereField("userId", isEqualTo: userId).getDocuments()
        DispatchQueue.main.async {
            self.workouts = querySnapshot.documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                
                // Safely unwrapping the data from Firestore
                let timestamp = data["date"] as? Timestamp
                let approvingState = data["approvingState"] as? String
                let workoutType = data["workoutType"] as? String
                let distance = data["distance"] as? Double
                let intensity = data["intensity"] as? String
                
                // Create and return a valid Workout instance
                return WorkoutF(id: id, date: timestamp?.dateValue() ?? Date(), approvingState: approvingState ?? WorkoutApprovalStatus.declined.rawValue, workoutType: workoutType ?? WorkoutType.bike.rawValue, distance: distance ?? 0, intensity: intensity ?? IntensityLevel.high.rawValue, athleteName: "")
            }
        }
    }
    
    func fetchWorkoutsForAthletes(athletes: [User]) async throws {
        let db = Firestore.firestore()
        
        for athlete in athletes {
            let querySnapshot = try await db.collection("workouts").whereField("userId", isEqualTo: athlete.id).getDocuments()
            
            DispatchQueue.main.async {
                let athleteWorkouts = querySnapshot.documents.compactMap { document in
                    let data = document.data()
                    let id = document.documentID
                    let timestamp = data["date"] as? Timestamp
                    let approvingState = data["approvingState"] as? String
                    let workoutType = data["workoutType"] as? String
                    let distance = data["distance"] as? Double
                    let intensity = data["intensity"] as? String
                    
                    // Return WorkoutF with athleteName included
                    return WorkoutF(id: id, date: timestamp?.dateValue() ?? Date(), approvingState: approvingState ?? WorkoutApprovalStatus.declined.rawValue, workoutType: workoutType ?? WorkoutType.bike.rawValue, distance: distance ?? 0, intensity: intensity ?? IntensityLevel.high.rawValue, athleteName: athlete.fullname)
                }
                self.workouts.append(contentsOf: athleteWorkouts)
            }
        }
    }
    
    func fetchWorkoutSplits(for workoutId: String) async throws -> [WorkoutSplit] {
        let db = Firestore.firestore()
        let splitsSnapshot = try await db.collection("workouts").document(workoutId).collection("workoutSplits").getDocuments()
        
        // Convert documents to WorkoutSplit objects
        let splits = splitsSnapshot.documents.compactMap { document -> WorkoutSplit? in
            let data = document.data()
            let id = Int(document.documentID) ?? 0 // Assuming the split ID is stored in the document ID
            let distance = data["distance"] as? Double ?? 0
            let splitspeed = data["splitspeed"] as? Double ?? 0
            let splitIntensity = data["splitIntensity"] as? String ?? ""
            let splitworkouttype = data["splitworkouttype"] as? String ?? ""
            let comment = data["comment"] as? String ?? ""
            
            return WorkoutSplit(id: id, workoutId: Int(workoutId) ?? 0, athleteID: "", distance: distance, splitspeed: splitspeed, splitIntensity: splitIntensity, splitworkouttype: splitworkouttype, comment: comment)
        }
        
        return splits
    }
    
    func updateWorkoutApprovalStatus(workoutId: String, status: String) async throws {
        let db = Firestore.firestore()
        let workoutRef = db.collection("workouts").document(workoutId)
        
        try await workoutRef.updateData(["approvingState": status])
    }
    
    // Function to update a workout split in Firestore
    func updateWorkoutSplit(workoutId: String, split: WorkoutSplit) async throws {
            let db = Firestore.firestore()
            let splitRef = db.collection("workouts").document(workoutId).collection("workoutSplits").document(String(split.id))
        print(split)
            let splitData: [String: Any] = [
                "distance": split.distance,
                "splitspeed": split.splitspeed,
                "splitIntensity": split.splitIntensity,
                "splitworkouttype": split.splitworkouttype,
                "comment": split.comment
            ]
            
            do {
                try await splitRef.updateData(splitData) // Update Firestore with new split data
            } catch {
                print("Error updating workout split: \(error.localizedDescription)")
                throw error
            }
        }
    
    // New function to update workout distance based on splits
    func updateWorkoutDistance(workoutId: String, distance: Double) async throws {
        let db = Firestore.firestore()
        let workoutRef = db.collection("workouts").document(workoutId)
        
        try await workoutRef.updateData(["distance": distance])
    }
}

