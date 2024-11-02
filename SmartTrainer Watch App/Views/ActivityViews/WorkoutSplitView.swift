//
//  WorkoutSplitView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 02.11.2024.
//

import SwiftUI

struct WorkoutSplitView: View {
    //@EnvironmentObject var dbManager: DBManager
    
    var comparisonDistance: Double // Distance to compare against
    
    var firstSplit: WorkoutSplit? {
        // Fetching the first workout split from the database
        let db = DBManager()
        let splits = db.readWorkoutSplits() // Ensure this method is fetching workout splits
        return splits.first // Get the first split for demonstration
    }
    
    var cumulativeDistances: [Double] {
        // Fetch workout splits from the database
        let db = DBManager()
        let splits = db.readWorkoutSplits() // Ensure this method is fetching workout splits
        var distances: [Double] = []
        var currentSum: Double = 0.0
        
        // Sum the distances from each split
        for split in splits {
            currentSum += split.distance // Sum the distance of each split
            distances.append(currentSum) // Append the cumulative sum
        }
        
        return distances
    }
    
    var firstExceedingSplitIndex: Int? {
        // Find the index of the first cumulative distance that exceeds comparisonDistance
        return cumulativeDistances.firstIndex(where: { $0 > comparisonDistance/1000 })
    }
    
    var body: some View {
        VStack {
            if let index = firstExceedingSplitIndex {
                let db = DBManager()
                let splits = db.readWorkoutSplits() // Fetch splits again to get the correct one
                let selectedSplit = splits[index]
                
                
                Text("Split: \(selectedSplit.id)")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.yellow)
                Text("\(selectedSplit.distance, specifier: "%.1f") km")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text("\(selectedSplit.splitspeed * 3.6, specifier: "%.1f") km/h")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text("\(selectedSplit.comment)")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
        }
        .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
        
    }
    
}


#Preview {
    WorkoutSplitView(comparisonDistance: 1)
}
