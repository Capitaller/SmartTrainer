//
//  MainView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 29.09.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            // Text in the middle of the screen
            VStack {
                Spacer()
                Text("Welcome to MainView")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

#Preview {
    MainView()
}
