//
//  TraininigOperationsManager.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 26.05.2024.
//

import Foundation
import HealthKit

class TraininigOperationsManager {
    private let training: HKWorkoutSession
    private let viewModel: TrainingViewModel
    
    init(training: HKWorkoutSession, viewModel: TrainingViewModel) {
        self.training = training
        self.viewModel = viewModel
    }
    
    func pause() {
        training.pause()
    }
    
    func resume() {
        training.resume()
    }
    
    func endTraining() {
        training.end()
        viewModel.isActiveSummaryView = true
    }
    func newTraining() {
            viewModel.activeEnergy_training = 0
            viewModel.averageHeartRate_training = 0
            viewModel.heartRate_training = 0
            viewModel.distance_training = 0
            viewModel.activeTraining = nil
            viewModel.dataB = nil
            viewModel.workout = nil
            viewModel.training = nil
            
            //speed = 0
        }
    func statisticsUpdate(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.viewModel.heartRate_training = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.viewModel.averageHeartRate_training = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.viewModel.activeEnergy_training = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.viewModel.distance_training = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
}

