//
//  HealthViewModel.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation
import HealthKit


class HealthViewModel: ObservableObject {
    
    // Published variables to store fetched health data
    @Published var weight: Double?
    @Published var userId: Int = 1
    @Published var email: String = "example@example.com"
    @Published var date: String = "2024-10-12"
    @Published var age: Int? // Property for age
    @Published var avgspeed: Double?
    
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
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        ]

        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("HealthKit authorization successful.")
                

            } else {
                if let error = error {
                    print("HealthKit authorization failed with error: \(error.localizedDescription)")
                } else {
                    print("HealthKit authorization failed without error message.")
                }
            }
        }
    }
    func RequestWorkout(distance: Double, intensity: IntensityLevel, workoutType: WorkoutType, athleteID: String) {
        //self.fetchHealthData(workoutType: workoutType) // Automatically fetch data after authorization
        
        self.fetchAge { age in
            guard let age = age else {
                print("Age is not available.")
                return
            }

            self.fetchAverageWorkoutSpeed(for: workoutType.hkWorkoutActivityType) { averageSpeed in
                guard let averageSpeedMS = averageSpeed else {
                    print("Average Speed is not available.")
                    return
                }
                
                self.fetchWeight { weight in
                    guard let weightR = weight else {
                        print("Weight is not available.")
                        return
                    }
                }

                // Now that we have the data, we can format it into the JSON string
                let jsonString = self.generateUserJSON(
                    workoutType: workoutType.rawValue,
                    intensity: intensity.rawValue,
                    distance: distance,
                    averageSpeedMS: averageSpeedMS, // Use the fetched average speed
                    athleteID: athleteID,
                    age: age, // Use unwrapped value
                    weight: self.weight ?? 60 // Use unwrapped value
                )
                //print(jsonString)

                sendJsonToAPI(jsonString: jsonString)
            }
        }
    }

    
    // MARK: - Fetch Health Data
//    func fetchHealthData(workoutType: WorkoutType) {
//        fetchWeight()
//    }
    
    // MARK: - Fetch Weight
     func fetchWeight(completion: @escaping (Double?) -> Void) {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight type is unavailable.")
            completion(nil)
            return
        }

        // Set up a query to fetch weight data
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (_, samples, error) in
            
            if let error = error {
                print("Error fetching weight data: \(error.localizedDescription)")
                completion(nil) // Call completion with nil on error
                return
            }
            
            guard let sample = samples?.first as? HKQuantitySample else {
                print("No weight data available.")
                completion(nil) // Call completion with nil if no sample is found
                return
            }
            
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            DispatchQueue.main.async {
                self.weight = weightInKg
                print("Weight: \(weightInKg) kg")
                completion(weightInKg) // Call completion with the fetched weight
            }
        }
        
        healthStore.execute(query)
    }


    
    // MARK: - Fetch Age
    func fetchAge(completion: @escaping (Int?) -> Void) {
        // Check if HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available.")
            completion(nil) // Call completion with nil if HealthKit is not available
            return
        }
        
        // Fetch the date of birth components
        do {
            let dateOfBirthComponents = try healthStore.dateOfBirthComponents() // Fetch date of birth components
            
            // Calculate age
            let ageComponents = Calendar.current.dateComponents([.year], from: dateOfBirthComponents.date!, to: Date())
            
            DispatchQueue.main.async {
                completion(ageComponents.year) // Call completion with the calculated age
            }
            
            print(ageComponents.year!) // Print age

        } catch {
            print("Error fetching date of birth: \(error.localizedDescription)") // Handle error
            DispatchQueue.main.async {
                completion(nil) // Call completion with nil on error
            }
        }
    }

    
    // MARK: - Fetch Average Workout Speed
    func fetchAverageWorkoutSpeed(for workoutType: HKWorkoutActivityType, completion: @escaping (Double?) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: workoutType)
        
        let now = Date()
        guard let startDate = Calendar.current.date(byAdding: .month, value: -2, to: now) else { return }
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate, datePredicate])
        
        let query = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: compoundPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let workouts = results as? [HKWorkout], error == nil else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil) // Return nil if there was an error
                return
            }
            
            // Calculate total distance and time
            var totalDistance: Double = 0
            var totalDuration: Double = 0
            
            for workout in workouts {
                if let distance = workout.totalDistance?.doubleValue(for: HKUnit.meter()), distance > 0 {
                    totalDistance += distance
                    totalDuration += workout.duration
                }
            }
            
            // Calculate average speed (meters per second)
            let averageSpeed = totalDuration > 0 ? (totalDistance / totalDuration) : nil
            DispatchQueue.main.async {
                completion(averageSpeed) // Return the average speed
            }
        }
        
        healthStore.execute(query)
    }

    
    func generateUserJSON(workoutType: String, intensity: String, distance: Double, averageSpeedMS: Double, athleteID: String, age: Int, weight: Double) -> String {
        // Create the messages part
        let systemMessage = """
        {
            "role": "system",
            "content": "You are a personal fitness trainer. RETURN ONLY JSON WITH WORKOUTSPLITS. NO TEXT EXCEPT JSON. NO OTHER JSON PARTS EXCEPR WORKOUTSPLITS."
        }
        """

        let assistantMessage = """
        {
            "role": "assistant",
            "content": "You are going to receive workout parameters such as Workout Type(Running, Cycling, Walking), Workout Intensity (Low/Medium/High), Desired workout distance (in km), athlete age, Weight and GENDER in JSON. You should return workout splits formatted in JSON file. You will get JSON with user data You should create new workoutsplits in this JSON AND RETURN ONLY workoutSplits. GENERATE UP TO 5 WORKOUT SPLITS RETURN ONLY workoutSplits JSON PART. every first split shuld be with lower intensity (warm-up). Generate different WORKOUT splits, you can change workout intensity, speed (meters per second) and distance for every new split, but the overall result should match general workout settings. DISTANCE IN EACH SPLIT CAN BE DIFFERENT BUT TOTAL DISTANCE IN ALL WORKOUT SPLITS SHOULD BE THE SAME AS MAXDISTANCE. SPLITINTENSITY CAN NOT BE MORE INTENSIVE THAN IN GIVEN intensity PARAMETR, BUT CAN BE LESS INTENSIVE. averageSpeedMS is an average speed in athlete workouts with the same type for several previous workouts. FOR LOW WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed LOWER THAN Value IN averageSpeedMS. FOR MEDIUM WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed SIMILAR TO Value IN averageSpeedMS.FOR HIGH WORKOUT INTENSITY CREATE SPLITS WITH TOTAL AVERAGE speed HIGHER THAN Value IN averageSpeedMS. DIFFERENCE IN SPEED FROM FASTEST TO LOWEST SPLIT SHOUD NOT BE MORE THAN 50% FROM GIVEN IN speed PARAMETR. DO NOT CREATE DIFFERENT SPLITS WITH THE SAME speed IN A ROW. SPLITS WITH THE SAME SPEED SHOUD HAVE THE SAME INTENSITY. RETURN ONLY workoutSplits JSON PART. NO TEXT EXCEPT JSON."
        }
        """

        // Create the user message
        let userMessage = """
        {
            "role": "user",
            "content": "{\\"workout\\":[{\\"id\\":101,\\"AthleteID\\":\\"\(athleteID)\\",\\"type\\":\\"\(workoutType)\\",\\"intensity\\":\\"\(intensity)\\",\\"distance\\":\(distance),\\"averageSpeedMS\\":\(averageSpeedMS),\\"workoutSplits\\":[{\\"id\\":1,\\"workoutId\\":\\"101\\",\\"AthleteID\\":\\"\(athleteID)\\",\\"distance\\":\\"distanceValue\\",\\"splitspeed\\":\\"speed\\",\\"splitIntensity\\":\\"splitIntensity\\",\\"splitworkouttype\\":\\"splitworkouttype\\",\\"comment\\":\\"\\"}]},{\\"userHealthData\\":{\\"athleteID\\":\\"\(athleteID)\\",\\"age\\":\(age),\\"weight\\":\(weight)}}]}"
        }
        """

        // Combine all parts into a single JSON string
        let jsonString = """
        {
            "messages": [\(systemMessage), \(assistantMessage), \(userMessage)],
            "temperature": 0.7,
            "top_p": 0.95
        }
        """

        return jsonString
    }


}
func sendJsonToAPI(jsonString: String) {
    guard let url = URL(string: "https://smarttrainer.openai.azure.com/openai/deployments/gpt-35-turbo/chat/completions?api-version=2023-03-15-preview") else {
        print("Invalid URL")
        return
    }
    
    // Load the API key from the .env file
    let env = Env.load()
    guard let apiKey = env["API_KEY"] else {
        print("API Key not found in .env file")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "api-key") // Set the api-key header
    request.httpBody = jsonString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error sending request: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data returned")
            return
        }

        do {
            // Parse the JSON response
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let extractedContent = extractWorkoutSplits(from:content)
                // Clean the content string
                let cleanedContent = extractedContent
                    .replacingOccurrences(of: "\\n", with: "") // Remove newline characters
                    .replacingOccurrences(of: "\\", with: "")  // Remove backslashes
                print(content)
                // Parse the cleaned JSON for workout splits
                if let contentData = cleanedContent.data(using: .utf8) {
                    if let workoutJson = try JSONSerialization.jsonObject(with: contentData, options: []) as? [String: Any],
                       let workoutSplits = workoutJson["workoutSplits"] as? [[String: Any]] {

                        // Iterate through each workout split and print details
                        for split in workoutSplits {
                            print("Workout Split ID: \(split["id"] ?? "")")
                            print("Workout ID: \(split["workoutId"] ?? "")")
                            print("Athlete ID: \(split["AthleteID"] ?? "")")
                            print("Distance: \(split["distance"] ?? "")")
                            print("Split Speed: \(split["splitspeed"] ?? "")")
                            print("Split Intensity: \(split["splitIntensity"] ?? "")")
                            print("Split Workout Type: \(split["splitworkouttype"] ?? "")")
                            print("Comment: \(split["comment"] ?? "")")
                            print("-------------")
                        }
                    } else {
                        print("Error parsing content JSON")
                    }
                }
            } else {
                print("Unexpected JSON structure")
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}

func extractWorkoutSplits(from content: String) -> String {
    // Regular expression to match the JSON block for workoutSplits
    let regexPattern = "\\{\\s*\"workoutSplits\"\\s*:\\s*\\[.*?\\]\\s*\\}"

    // Create a regular expression object
    let regex = try! NSRegularExpression(pattern: regexPattern, options: [.dotMatchesLineSeparators])

    // Find matches in the content string
    if let match = regex.firstMatch(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count)) {
        if let range = Range(match.range, in: content) {
            let jsonContent = String(content[range])
            return jsonContent
        }
    }
    return "" // Return an empty string if no match is found
}




