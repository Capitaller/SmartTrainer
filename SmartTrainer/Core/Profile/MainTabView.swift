//
//  MainTabView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 29.09.2024.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser{
            TabView(selection: $selectedTab) {
                
                if user.type == .trainer {
                    TrainerAthletesView()
                        .tabItem {
                            Image(systemName: "person.crop.badge.magnifyingglass")
                            Text("Athletes")
                        }
                        .tag(0)
                    
                    
                }
                
                // Show "Workouts" tab if the user is an athlete
                if user.type == .athlete {
                    Text("Workouts")
                        .tabItem {
                            Image(systemName: "figure.run.circle")
                            Text("Workouts")
                        }
                        .tag(1)
                    WorkoutSettingsView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                }
                
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
                
                
            }
        }
    }
}

#Preview {
    MainTabView()
}
