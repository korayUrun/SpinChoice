//
//  AddOptionView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct AddOptionView: View {
    @Environment(\.dismiss) var dismiss
    var onAdd: (WheelOption) -> Void
    
    @State private var optionName = ""
    @State private var weight = 1
    
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
                
                VStack(spacing: 32) {
                    // Option Name
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Option Name")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        TextField("e.g., League of Legends", text: $optionName)
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
                    
                    // Weight/Votes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Number of Votes")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                if weight > 1 {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        weight -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(weight > 1 ? Color(hex: "FF6B9D") : Color.white.opacity(0.2))
                            }
                            .disabled(weight <= 1)
                            
                            Text("\(weight)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "6C5CE7"), Color(hex: "00B8D4")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(minWidth: 100)
                                .contentTransition(.numericText())
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    weight += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(Color(hex: "00D9A3"))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Add Option")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "FF6B9D"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        let option = WheelOption(name: optionName, weight: weight)
                        onAdd(option)
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00D9A3"))
                    .fontWeight(.semibold)
                    .disabled(optionName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddOptionView { _ in }
}
