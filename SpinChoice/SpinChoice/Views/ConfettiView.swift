//
//  ConfettiView.swift
//  SpinChoice
//
//  Created on November 5, 2025.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    
    let colors: [Color] = [
        Color(hex: "6C5CE7"),
        Color(hex: "00B8D4"),
        Color(hex: "FF6B9D"),
        Color(hex: "00D9A3"),
        Color(hex: "FDCB6E"),
        Color(hex: "A29BFE")
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { index in
                ConfettiPiece(color: colors[index % colors.count])
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -400...800) : -100
                    )
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...720) : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 1.5...3.0))
                        .delay(Double.random(in: 0...0.3)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let shape = Int.random(in: 0...2)
    
    var body: some View {
        Group {
            if shape == 0 {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            } else if shape == 1 {
                Rectangle()
                    .fill(color)
                    .frame(width: 8, height: 12)
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 6, height: 10)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfettiView()
    }
}
