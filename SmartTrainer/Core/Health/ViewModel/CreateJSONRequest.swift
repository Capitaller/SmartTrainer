//
//  CreateJSONRequest.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 12.10.2024.
//

import Foundation


    class CreateJSONRequest: ObservableObject {
        // Variables and methods for HealthKit data fetching

        // Create function to generate JSON with dynamic user data
        func createRequestJSON(user: UserData, healthData: HealthData, vo2maxData: [VO2MaxData]) -> String? {
            // Use messages from the RoleMessages struct
            let systemMessage = Message(role: "system", content: RoleMessages.systemMessage)
            let assistantMessage = Message(role: "assistant", content: RoleMessages.assistantMessage)

            let userMessageContent = """
            {
                "user": \(encodeToString(user) ?? ""),
                "userHealthData": \(encodeToString(healthData) ?? ""),
                "VO2MAX": \(encodeToString(vo2maxData) ?? "")
            }
            """
            let userMessage = Message(role: "user", content: userMessageContent)

            let apiRequestBody = APIRequestBody(messages: [systemMessage, assistantMessage, userMessage], temperature: 0.7, top_p: 0.95)

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(apiRequestBody) {
                return String(data: jsonData, encoding: .utf8)
            } else {
                return nil
            }
        }

        // Helper function to encode an object to a string
        func encodeToString<T: Codable>(_ data: T) -> String? {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(data) {
                return String(data: jsonData, encoding: .utf8)
            } else {
                return nil
            }
        }
    }
