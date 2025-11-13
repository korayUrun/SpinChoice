//
//  CategoryViewModel.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadCategories()
    }
    
    // MARK: - Category Management
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    func deleteCategory(at indexSet: IndexSet) {
        categories.remove(atOffsets: indexSet)
        saveCategories()
    }
    
    // MARK: - Option Management
    
    func addOption(to category: Category, option: WheelOption) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].options.append(option)
            saveCategories()
        }
    }
    
    func updateOption(in category: Category, option: WheelOption) {
        if let categoryIndex = categories.firstIndex(where: { $0.id == category.id }),
           let optionIndex = categories[categoryIndex].options.firstIndex(where: { $0.id == option.id }) {
            categories[categoryIndex].options[optionIndex] = option
            saveCategories()
        }
    }
    
    func deleteOption(from category: Category, option: WheelOption) {
        if let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) {
            categories[categoryIndex].options.removeAll { $0.id == option.id }
            saveCategories()
        }
    }
    
    // MARK: - Persistence
    
    private func saveCategories() {
        persistenceManager.saveCategories(categories)
    }
    
    private func loadCategories() {
        categories = persistenceManager.loadCategories()
    }
}
