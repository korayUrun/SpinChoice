//
//  AddCategoryView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CategoryViewModel
    
    @State private var categoryName = ""
    @State private var options: [WheelOption] = []
    @State private var showingAddOption = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(hex: "1A1A2E"),
                        Color(hex: "16213E")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Category Name Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category Name")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                            
                            TextField("e.g., Friday Night Games", text: $categoryName)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                        .padding(.horizontal)
                        .padding(.top, 24)
                        
                        // Options Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Options")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Spacer()
                                
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    showingAddOption = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add")
                                    }
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(hex: "6C5CE7"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color(hex: "6C5CE7").opacity(0.2))
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                            
                            if options.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white.opacity(0.3))
                                    
                                    Text("No options yet")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(options) { option in
                                        OptionRowView(
                                            option: option,
                                            totalWeight: options.reduce(0) { $0 + $1.weight },
                                            onDelete: {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                    options.removeAll { $0.id == option.id }
                                                }
                                            }
                                        )
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)
                                        ))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("New Wheel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "FF6B9D"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        let category = Category(name: categoryName, options: options)
                        viewModel.addCategory(category)
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00D9A3"))
                    .fontWeight(.semibold)
                    .disabled(categoryName.isEmpty || options.count < 2)
                }
            }
            .sheet(isPresented: $showingAddOption) {
                AddOptionView { option in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        options.append(option)
                    }
                }
            }
        }
    }
}

#Preview {
    AddCategoryView()
        .environmentObject(CategoryViewModel())
}
