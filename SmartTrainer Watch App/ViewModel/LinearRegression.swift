//
//  LinearRegression.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 06.05.2024.
//

import Foundation

class LinearRegression
{
    func linearRegression(x: [Double],  y: [Double], distance: Double) -> Double? {
        guard x.count == y.count else {
            return nil 
        }
        
        let n = Double(x.count)
        let xMean = x.reduce(0, +) / n
        let yMean = y.reduce(0, +) / n
        
        var numerator = 0.0
        var denominator = 0.0
        
        for i in 0..<x.count {
            numerator += (x[i] - xMean) * (y[i] - yMean)
            denominator += (x[i] - xMean) * (x[i] - xMean)
        }
        
        guard denominator != 0 else {
            return nil // Return nil if denominator is zero
        }
        
        let slope = numerator / denominator
        let intercept = yMean - slope * xMean
        
        return slope * distance + intercept
    }

}
