//
//  Category.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import Foundation

struct Category: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var options: [WheelOption]
    var createdAt: Date
    
    init(name: String, options: [WheelOption] = []) {
        self.name = name
        self.options = options
        self.createdAt = Date()
    }
    
    var totalWeight: Int {
        options.reduce(0) { $0 + $1.weight }
    }
    
    var optionCount: Int {
        options.count
    }
}
