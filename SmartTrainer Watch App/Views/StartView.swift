//
//  ContentView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 29.01.2024.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var trainingViewModel: TrainingViewModel
    var workoutTypes:[HKWorkoutActivityType] = [.cycling,.running,.walking]
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, destination: SessionPagingView(),
                           tag: workoutType, selection: $trainingViewModel.activeTraining)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            .listStyle(.carousel)
            .navigationTitle("Workouts")
            .onAppear {
                trainingViewModel.requestAuthorization()
            }
            
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(TrainingViewModel())
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt{
        rawValue
    }
    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}
