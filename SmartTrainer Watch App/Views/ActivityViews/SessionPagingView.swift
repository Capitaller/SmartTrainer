//
//  SessionPagingView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 29.01.2024.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var trainingViewModel: TrainingViewModel
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection){
            ControlsView().tag(Tab.controls)
            MainView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(trainingViewModel.activeTraining?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: trainingViewModel.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
        
    }
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(TrainingViewModel())
    }
}
