//
//  EmptyStateView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    
    @State private var bounce = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "6C5CE7").opacity(0.2),
                                Color(hex: "00B8D4").opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6C5CE7"), Color(hex: "00B8D4")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .offset(y: bounce ? -10 : 0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: bounce)
            .onAppear {
                bounce = true
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                action()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text(buttonTitle)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "6C5CE7"), Color(hex: "A29BFE")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color(hex: "6C5CE7").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 8)
        }
        .padding(40)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        EmptyStateView(
            title: "No Wheels Yet!",
            subtitle: "Create your first decision wheel\nand let fate decide 🎡",
            buttonTitle: "Create Wheel",
            action: {}
        )
    }
}
