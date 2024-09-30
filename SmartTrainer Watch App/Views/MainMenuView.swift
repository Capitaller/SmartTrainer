//
//  MainMenuView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 11.02.2024.
//
import SwiftUI
import HealthKit

struct MainMenuView: View {
    @State private var selection: Tab = .startWorkout
    enum Tab {
        case Settings, startWorkout
    }
    var body: some View {
        TabView (selection: $selection){
            SettingsView().tabItem {
                Text("")
            }.tag(Tab.Settings)
            StartView().tabItem {
                Text("")
            }.tag(Tab.startWorkout)
        }
    }
}

struct MainManueView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView().environmentObject(TrainingViewModel())
    }
}
