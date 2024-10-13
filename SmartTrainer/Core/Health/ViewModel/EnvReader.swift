//
//  EnvReader.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 13.10.2024.
//

import Foundation

struct Env {
    static func load() -> [String: String] {
        var envVars: [String: String] = [:]
        
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil),
              let contents = try? String(contentsOf: url) else {
            print("Could not find or read .env file")
            return envVars
        }

        let lines = contents.split(whereSeparator: \.isNewline)
        for line in lines {
            let pair = line.split(separator: "=", maxSplits: 1)
            guard pair.count == 2 else { continue }
            let key = String(pair[0]).trimmingCharacters(in: .whitespaces)
            let value = String(pair[1]).trimmingCharacters(in: .whitespaces)
            envVars[key] = value
        }
        
        return envVars
    }
}
