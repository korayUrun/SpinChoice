//
//  PersistenceManager.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let categoriesKey = "spinChoice_categories"
    
    private init() {}
    
    func saveCategories(_ categories: [Category]) {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    func loadCategories() -> [Category] {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey),
              let decoded = try? JSONDecoder().decode([Category].self, from: data) else {
            return []
        }
        return decoded
    }
}
