//
//  WheelOption.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import Foundation

struct WheelOption: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var weight: Int // Number of votes/weight for this option
    
    init(name: String, weight: Int = 1) {
        self.name = name
        self.weight = weight
    }
    
    // Calculate percentage based on total weight
    func percentage(totalWeight: Int) -> Double {
        guard totalWeight > 0 else { return 0 }
        return Double(weight) / Double(totalWeight) * 100
    }
}
