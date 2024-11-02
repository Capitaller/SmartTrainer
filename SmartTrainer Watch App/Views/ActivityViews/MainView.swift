//
//  MainView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 29.01.2024.
//

import SwiftUI
import HealthKit
import CoreData



struct MainView: View {
    
    
    var body: some View {
        // The TimelineView displays a timeline of metrics using the MetricsTimelineSchedule.
        TimelineView(MetricsTimelineSchedule(from: trainingViewModel.dataB?.startDate ?? Date(), isPaused: trainingViewModel.training?.state == .paused)) { context in
            
            // The TabView displays two tabs: "Screen" and "Text".
            TabView {
                
                // Tab 1: "Screen" tab
                VStack(alignment: .leading) {
                    
                    // ElapsedTimeView shows the elapsed time with an option to show subseconds.
                    ElapsedTimeView(elapsedTime: trainingViewModel.dataB?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundStyle(.yellow)
                    //.font(.system(size: 15))
                    
                    // Display the active energy in kilocalories.
                    Text(Measurement(value: trainingViewModel.activeEnergy_training, unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                    
                    // Display the heart rate in beats per minute (bpm).
                    Text(trainingViewModel.heartRate_training.formatted(.number.precision(.fractionLength(0))) + " bpm")
                        .foregroundStyle(.red)
                    
                    // Display the distance in meters.
                    Text(Measurement(value: trainingViewModel.distance_training, unit: UnitLength.meters)
                        .formatted(.measurement(width: .abbreviated, usage: .road)))
                    let elapsedTimeInSeconds = trainingViewModel.dataB?.elapsedTime(at: Date()) ?? 1
                    let speedInMS = trainingViewModel.distance_training / elapsedTimeInSeconds // Distance in km divided by time in hours
                    let speedInKmh = speedInMS * 3.6 // Convert speed to km/h

                    Text("\(speedInKmh, specifier: "%.1f") km/h")
                }
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
                .tabItem {
                    Label("Metrics", systemImage: "")
                }
                VStack(alignment: .leading)
                {
                    WorkoutSplitView(comparisonDistance: trainingViewModel.distance_training)
                }
                // Tab 2: "Text" tab
                VStack(alignment: .leading)  {
                    
                    // Check if heart rate is too high and display appropriate messages.
                    if trainingViewModel.heartRate_training > (220 - Double(UserDefaults.standard.integer(forKey: ConstantsEnum.settingsNames.userAge))) {
                        Text("Stop!")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(ConstantsEnum.adviceNames.highHeartRate)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(trainingViewModel.heartRate_training.formatted(.number.precision(.fractionLength(0))) + " bpm")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        // Display the current advice.
                        Text(trainingViewModel.currentAdvice)
                            .font(.system(size: 30))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.yellow)
                    }
                }
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
                .tabItem {
                    Label("Text", systemImage: "")
                }
            }
            .tabViewStyle(.carousel)
        }
    }
    
    // Access the TrainingViewModel through the environment.
    @EnvironmentObject var trainingViewModel: TrainingViewModel
    
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(TrainingViewModel())
    }
}

//private struct MetricsTimelineSchedule: TimelineSchedule {
//    var startDate: Date
//    var isPaused: Bool
//
//    init(from startDate: Date, isPaused: Bool) {
//        self.startDate = startDate
//        self.isPaused = isPaused
//    }
//
//    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
//        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
//            .entries(from: startDate, mode: mode)
//
//        return AnyIterator<Date> {
//            guard !isPaused else { return nil }
//            return baseSchedule.next()
//        }
//    }
//
//}
