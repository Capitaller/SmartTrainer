//
//  WorkoutSplitsView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 14.10.2024.
//

import SwiftUI

struct WorkoutSplitsView: View {
    var body: some View {
        VStack {
            Text("Workout Splits")
                .font(.largeTitle)
                .padding()
            
            // Add your logic to show workout splits here
            List(0..<5) { index in
                Text("Split \(index + 1)")
            }
        }
        .navigationBarTitle("Workout Splits", displayMode: .inline)
    }
}

#Preview {
    WorkoutSplitsView()
}

