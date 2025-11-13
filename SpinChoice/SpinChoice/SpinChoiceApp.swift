//
//  SpinChoiceApp.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

@main
struct SpinChoiceApp: App {
    @StateObject private var categoryViewModel = CategoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(categoryViewModel)
                .preferredColorScheme(.dark) // Default to dark mode
        }
    }
}
