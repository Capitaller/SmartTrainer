//
//  ControlsView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 29.01.2024.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var trainingViewModel: TrainingViewModel

    var body: some View {
        HStack {
            VStack {
                Button {
                    trainingViewModel.endTraining()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                    trainingViewModel.togglePause()
                } label: {
                    Image(systemName: trainingViewModel.running ? "pause" : "play")
                }
                .tint(.yellow)
                .font(.title2)
                Text(trainingViewModel.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(TrainingViewModel())
    }
}
