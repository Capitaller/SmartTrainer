//
//  SmartTrainerApp.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 20.09.2024.
//

import SwiftUI
import Firebase

@main
struct UserAuthApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
