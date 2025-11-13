//
//  OptionsManagementView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct OptionsManagementView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CategoryViewModel
    @Binding var category: Category
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
                
                if category.options.isEmpty {
                    EmptyStateView(
                        title: "No Options",
                        subtitle: "Add at least 2 options\nto spin the wheel",
                        buttonTitle: "Add Option",
                        action: { showingAddOption = true }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(category.options) { option in
                                OptionRowView(
                                    option: option,
                                    totalWeight: category.totalWeight,
                                    onDelete: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            deleteOption(option)
                                        }
                                    }
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            showingAddOption = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "6C5CE7"),
                                            Color(hex: "A29BFE")
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: Color(hex: "6C5CE7").opacity(0.5), radius: 20, x: 0, y: 10)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Manage Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00D9A3"))
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingAddOption) {
                AddOptionView { option in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        addOption(option)
                    }
                }
            }
        }
    }
    
    private func addOption(_ option: WheelOption) {
        category.options.append(option)
        viewModel.updateCategory(category)
    }
    
    private func deleteOption(_ option: WheelOption) {
        category.options.removeAll { $0.id == option.id }
        viewModel.updateCategory(category)
    }
}

struct OptionRowView: View {
    let option: WheelOption
    let totalWeight: Int
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var percentage: Double {
        option.percentage(totalWeight: totalWeight)
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete button - arka planda, sadece swipe'da görünür
            if offset < -10 {
                HStack {
                    Spacer()
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        onDelete()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FF6B9D"))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "trash.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.trailing, 0)
                .transition(.scale.combined(with: .opacity))
            }
            
            // ANA KART - TEMİZ GÖRÜNÜM
            HStack(spacing: 16) {
                // Sol taraf - İsim ve bilgiler
                VStack(alignment: .leading, spacing: 8) {
                    Text(option.name)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text("\(option.weight) vote\(option.weight == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("•")
                            .foregroundColor(.white.opacity(0.4))
                        
                        Text("\(Int(percentage))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "00D9A3"))
                    }
                }
                
                Spacer()
                
                // Sağ taraf - Sadece yüzde çemberi (PEMBİ KUTU YOK!)
                ZStack {
                    // Arka plan çember
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 60, height: 60)
                    
                    // Dış çizgi
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        .frame(width: 60, height: 60)
                    
                    // Progress yay
                    Circle()
                        .trim(from: 0, to: percentage / 100)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "74B9FF"), Color(hex: "0984E3")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: percentage)
                    
                    // Yüzde yazısı
                    Text("\(Int(percentage))%")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            offset = max(gesture.translation.width, -80)
                        }
                    }
                    .onEnded { gesture in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if gesture.translation.width < -50 {
                                offset = -80
                            } else {
                                offset = 0
                            }
                        }
                    }
            )
        }
        .frame(height: 100)
        .clipped()
    }
}

#Preview {
    OptionsManagementView(
        category: .constant(Category(
            name: "Test",
            options: [
                WheelOption(name: "Option 1", weight: 3),
                WheelOption(name: "Option 2", weight: 2)
            ]
        ))
    )
    .environmentObject(CategoryViewModel())
}
