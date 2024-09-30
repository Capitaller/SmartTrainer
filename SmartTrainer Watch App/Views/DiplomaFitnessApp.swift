//
//  SmartTrainerApp.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 29.01.2024.
//

import SwiftUI

@main
struct SmartTrainer_Watch_App: App {
    @StateObject var trainingViewModel = TrainingViewModel()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView{
                MainMenuView()
                //DistanceView()
            }
            .sheet(isPresented: $trainingViewModel.isActiveSummaryView) {
                SummaryView()
            }
            .environmentObject(trainingViewModel)
        }
    }
}
