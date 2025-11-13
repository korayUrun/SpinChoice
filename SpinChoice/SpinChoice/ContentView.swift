//
//  ContentView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CategoriesListView()
    }
}

#Preview {
    ContentView()
        .environmentObject(CategoryViewModel())
}
