//
//  TrainingViewModel.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 04.02.2024.
//

import Foundation
import HealthKit
import CoreLocation

class TrainingViewModel: NSObject, ObservableObject {
    
    var timer: Timer?
    let hkHealthStore = HKHealthStore()
    var training: HKWorkoutSession?
    var dataB: HKLiveWorkoutBuilder?
    var count: Int = 1
    var trainingId: Int = 0
    var trainingType: String = ""
    var workoutsNumber: Int = 0
    var currentAdvice: String = ConstantsEnum.adviceNames.keepMoving
    @Published var averageHeartRate_training: Double = 0
    @Published var heartRate_training: Double = 0
    @Published var activeEnergy_training: Double = 0
    @Published var distance_training: Double = 0
    //@Published var speed: Double = 0
    @Published var workout: HKWorkout?
    @Published var location_training: HKWorkoutRoute?
    @Published var power_training: Double = 0
    @Published var isActiveSummaryView: Bool = false {
        didSet {
            if isActiveSummaryView == false {
                workoutSessionManager?.newTraining()
            }
        }
    }
    @Published var running = false {
        didSet {
            if running {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    private var workoutSessionManager: TraininigOperationsManager?
    
    // Starts the timer with a given time interval
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.addTrainingSplit()
            
            // Check if the number of workouts is greater than 3
            if (self!.workoutsNumber > 3) {
                self?.predictEnergy()
            }
        }
    }
    
    // Stops the timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var activeTraining: HKWorkoutActivityType? {
        didSet {
            guard let selectedTraining = activeTraining else { return }
            startTraining(workoutType: selectedTraining)
        }
    }
    
    
    
    // Requests authorization for accessing health data
    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!
        ]
        
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]
        
        hkHealthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
    
    // Starts the workout session with a given workout type
    func startTraining(workoutType: HKWorkoutActivityType) {
        startTimer()
        self.trainingType = String(workoutType.name)
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        do {
            training = try HKWorkoutSession(healthStore: hkHealthStore, configuration: configuration)
            dataB = training?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        training?.delegate = self
        dataB?.delegate = self
        
        dataB?.dataSource = HKLiveWorkoutDataSource(healthStore: hkHealthStore,
                                                     workoutConfiguration: configuration)
        
        let startDate = Date()
        training?.startActivity(with: startDate)
        dataB?.beginCollection(withStart: startDate) { (success, error) in
            let db = DBManager()
            let date = Date() // the current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var workouts = db.read(type: workoutType.name)
            self.workoutsNumber = workouts.count
            
            // Check if the number of workouts is greater than 100 and delete the oldest workout
            if (self.workoutsNumber > 100) {
                db.deleteRowByID(id: workouts[0].id)
            }
            
            workouts = db.read()
            let id = workouts.last?.id ?? 0
            self.trainingId = id + 1
            db.insert(id: self.trainingId, date: dateFormatter.string(from: date), type: String(workoutType.name))
            self.workoutSessionManager = TraininigOperationsManager(training: self.training!, viewModel: self)
        }
    }
    
    
    
    // Toggles the pause state of the workout session
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    
    
    // Updates the statistics based on the received HKStatistics object
    func statisticsUpdate(_ statistics: HKStatistics?) {
        workoutSessionManager?.statisticsUpdate(statistics)
    }
    

    // Pauses the workout session
    func pause() {
        workoutSessionManager?.pause()
    }
    
    // Resumes the workout session
    func resume() {
        workoutSessionManager?.resume()
    }
    
    // Ends the workout session
    func endTraining() {
        workoutSessionManager?.endTraining()
    }

    // Adds a training split to the database
    func addTrainingSplit() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let db = DBManager()
        let trainingSplits = db.readTrainingSplits()
        let trainingSplitId = trainingSplits.last?.id ?? 0
        db.insertTrainingSplits(id: trainingSplitId + 1, workoutId: self.trainingId, time: dateFormatter.string(from: Date()), heartRate: self.heartRate_training, activeEnergy: self.activeEnergy_training, distance: self.distance_training)
    }
    
    // Predicts energy based on training data and provides advice
    func predictEnergy() {
        let db = DBManager()
        let (_, activeEnergy, distance, heartRate) = db.readTrainingSplits(worloutId: self.trainingId)
        let lg = LinearRegression()
        var energy: Double
        
        let userDistance = Double(UserDefaults.standard.integer(forKey: ConstantsEnum.settingsNames.userDistance) * 100)
        
        //print(distance.last!)
        if distance.last! > Double(userDistance / 4) {
            energy = lg.linearRegression(x: distance, y: activeEnergy, distance: userDistance) ?? 0
            let (trainingSplits2, activeEnergy2, _, _) = db.readTrainingSplits(type: self.trainingType, Distance: userDistance)
            if (activeEnergy2.count != 0) {
                let activeEnergyMaxTrainingId = activeEnergy2.firstIndex(of: activeEnergy2.max()!)!
                let (_, _, _, heartRateAvg) = db.readTrainingSplits(type: self.trainingType, worloutId: trainingSplits2[activeEnergyMaxTrainingId].workoutId, distance: distance.last!)
                let sumHCurrent  = heartRate.reduce(0, +)
                _ = Double(sumHCurrent) / Double(heartRate.count)
                let sumHRecorder  = heartRateAvg.reduce(0, +)
                let meanHRecorder = Double(sumHRecorder) / Double(heartRateAvg.count)
                if (energy > activeEnergy2.max()! && sumHCurrent > meanHRecorder) {
                    print(ConstantsEnum.adviceNames.reducePace)
                    self.currentAdvice = ConstantsEnum.adviceNames.reducePace
                }
                if (energy < activeEnergy2.min()! && sumHCurrent < meanHRecorder) {
                    print(ConstantsEnum.adviceNames.increasePace)
                    self.currentAdvice = ConstantsEnum.adviceNames.increasePace
                } else {
                    print(ConstantsEnum.adviceNames.keepMoving)
                    self.currentAdvice = ConstantsEnum.adviceNames.keepMoving
                }
            } else {
                let (_, _, distanceMax, _) = db.readTrainingSplits(type: self.trainingType)
                energy =  lg.linearRegression(x: distance, y: activeEnergy, distance: distanceMax.max()!)!
                let (_, activeEnergy3, _, _) = db.readTrainingSplits(type: self.trainingType, Distance: distanceMax.max()!)
                if (energy > activeEnergy3.max()! * 0.9) {
                    print(ConstantsEnum.adviceNames.reducePace)
                    self.currentAdvice = ConstantsEnum.adviceNames.reducePace
                } else {
                    print(ConstantsEnum.adviceNames.keepMoving)
                    self.currentAdvice = ConstantsEnum.adviceNames.keepMoving
                }
            }
        }
    }
}


