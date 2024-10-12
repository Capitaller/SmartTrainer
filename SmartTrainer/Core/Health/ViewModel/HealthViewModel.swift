//
//  HealthViewModel.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation
import HealthKit
import SwiftUI

class HealthViewModel: ObservableObject {
    
    // Published variables to store fetched health data
    @Published var weight: Double?
    @Published var vo2Max: Double?
    @Published var userId: Int = 1
    @Published var email: String = "example@example.com"
    @Published var date: String = "2024-10-12"
    @Published var age: Int? // Property for age
    
    private var healthStore = HKHealthStore()
    
    // MARK: - Request HealthKit Authorization
    func requestHealthKitAuthorization() {
        // Ensure HealthKit is available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available on this device.")
            return
        }

        // Define the types of data we want to read from HealthKit
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
            
            // Note: No need to include dateOfBirth here
        ]

        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("HealthKit authorization successful.")
                self.fetchHealthData() // Automatically fetch data after authorization
                self.fetchAge() // Fetch age after authorization
            } else {
                if let error = error {
                    print("HealthKit authorization failed with error: \(error.localizedDescription)")
                } else {
                    print("HealthKit authorization failed without error message.")
                }
            }
        }
    }
    
    // MARK: - Fetch Health Data
    func fetchHealthData() {
        fetchWeight()
        fetchVO2Max()
        // No longer need to call fetchAge here since it's called after authorization
    }
    
    private func fetchWeight() {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight type is unavailable.")
            return
        }

        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: nil) { (_, samples, error) in
            guard let sample = samples?.first as? HKQuantitySample else {
                print("No weight data available: \(String(describing: error))")
                return
            }
            
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            DispatchQueue.main.async {
                self.weight = weightInKg
                print("Weight: \(weightInKg) kg")
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchVO2Max() {
        guard let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max) else {
            print("VO2Max type is unavailable.")
            return
        }

        // Create a query to fetch VO2Max samples
        let query = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            guard error == nil else {
                print("Error fetching VO2Max data: \(error!.localizedDescription)")
                return
            }

            // Process the results
            if let samples = results as? [HKQuantitySample] {
                for sample in samples {
                    let VO2Unit = HKUnit(from: "ml/kg*min")
                    let vo2MaxValue = sample.quantity.doubleValue(for: VO2Unit)
                    print("VO2Max: \(vo2MaxValue) mL/kg/min")
                }
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }

    func fetchAge() {
        // Check if HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available.")
            return
        }
        // Fetch the date of birth components
        do {
            let dateOfBirthComponents = try healthStore.dateOfBirthComponents() // Fetch date of birth components
            let ageComponents = Calendar.current.dateComponents([.year], from: dateOfBirthComponents.date!, to: Date())
            DispatchQueue.main.async {
                self.age = ageComponents.year! 
            }
            print(ageComponents.year!) // Print age

        } catch {
            print("Error fetching date of birth: \(error.localizedDescription)") // Handle error
            DispatchQueue.main.async {
                self.age = nil // Reset age on error
            }
        }
    }

}
