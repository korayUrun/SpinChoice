//
//  CategoriesListView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct CategoriesListView: View {
    @EnvironmentObject var viewModel: CategoryViewModel
    @State private var showingAddCategory = false
    @State private var animateCards = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "1A1A2E"),
                        Color(hex: "16213E"),
                        Color(hex: "0F3460")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if viewModel.categories.isEmpty {
                    EmptyStateView(
                        title: "No Wheels Yet!",
                        subtitle: "Create your first decision wheel\nand let fate decide 🎡",
                        buttonTitle: "Create Wheel",
                        action: { showingAddCategory = true }
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Array(viewModel.categories.enumerated()), id: \.element.id) { index, category in
                                NavigationLink(destination: WheelSpinnerView(category: category)) {
                                    CategoryCard(category: category)
                                        .opacity(animateCards ? 1 : 0)
                                        .offset(y: animateCards ? 0 : 20)
                                        .animation(
                                            .spring(response: 0.6, dampingFraction: 0.8)
                                            .delay(Double(index) * 0.1),
                                            value: animateCards
                                        )
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            viewModel.deleteCategory(category)
                                        }
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
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
                            showingAddCategory = true
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
                        .rotationEffect(.degrees(showingAddCategory ? 45 : 0))
                        .scaleEffect(showingAddCategory ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddCategory)
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("SpinChoice")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView()
            }
            .onAppear {
                animateCards = true
            }
        }
    }
}

struct CategoryCard: View {
    let category: Category
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "circle.hexagonpath.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6C5CE7"), Color(hex: "00B8D4")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Spacer()
                
                Text("\(category.optionCount)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                    )
            }
            
            Text(category.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Text(category.optionCount == 1 ? "1 option" : "\(category.optionCount) options")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(
            ZStack {
                // Glassmorphism effect
                RoundedRectangle(cornerRadius: 24)
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
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
            }
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    CategoriesListView()
        .environmentObject(CategoryViewModel())
}
