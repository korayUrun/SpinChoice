//
//  WheelSpinnerView.swift
//  SpinChoice
//
//  Completely rewritten on November 6, 2025.
//

import SwiftUI

struct WheelSpinnerView: View {
    @EnvironmentObject var viewModel: CategoryViewModel
    @Environment(\.dismiss) var dismiss
    @State private var category: Category
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var selectedOption: WheelOption?
    @State private var showResult = false
    @State private var showingOptionsSheet = false
    @State private var showConfetti = false
    
    init(category: Category) {
        _category = State(initialValue: category)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.makeBody(geometry: geometry)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Menu")
                            .font(.system(size: 17, weight: .medium))
                    }
                    .foregroundColor(Color(hex: "00B8D4"))
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "FDCB6E"))
                    
                    Text(category.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "FDCB6E"))
                        .lineLimit(1)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "FDCB6E"))
                }
                .shadow(color: Color(hex: "FF6B9D").opacity(0.3), radius: 5, x: 0, y: 2)
            }
        }
        .sheet(isPresented: $showingOptionsSheet) {
            OptionsManagementView(category: $category)
        }
        .onChange(of: category) { newValue in
            viewModel.updateCategory(newValue)
        }
        .onAppear {
            if let updated = viewModel.categories.first(where: { $0.id == category.id }) {
                category = updated
            }
        }
    }
    
    @ViewBuilder
    private func makeBody(geometry: GeometryProxy) -> some View {
        let wheelSize = min(geometry.size.width * 0.85, geometry.size.height * 0.4)
        
        ZStack {
            // Background
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
            
            VStack(spacing: 0) {
                // Wheel with pointer
                ZStack {
                    // Pointer at top - FIXED POSITION
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: wheelSize * 0.09))
                        .foregroundColor(Color(hex: "FF6B9D"))
                        .shadow(color: Color(hex: "FF6B9D").opacity(0.6), radius: 10, x: 0, y: 5)
                        .offset(y: -wheelSize * 0.53)
                        .zIndex(10)
                    
                    // The Wheel
                    if category.options.count >= 2 {
                        SpinningWheel(options: category.options, rotation: rotation)
                            .frame(width: wheelSize, height: wheelSize)
                    } else {
                        // Need more options state
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.yellow.opacity(0.8))
                            
                            Text("Need at least 2 options\nto spin the wheel")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: wheelSize, height: wheelSize)
                    }
                }
                .padding(.top, geometry.size.height * 0.1)
                .offset(y: showResult ? -geometry.size.height * 0.06 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showResult)
                
                Spacer()
                
                // Buttons - FIXED POSITION
                VStack(spacing: 16) {
                    // Spin Button
                    if !isSpinning {
                        Button(action: spinWheel) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                    .font(.title3)
                                
                                Text(showResult ? "Spin Again" : "Spin the Wheel")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
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
                        .disabled(category.options.count < 2)
                        .opacity(category.options.count < 2 ? 0.5 : 1)
                    } else {
                        // Spinning indicator
                        HStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            
                            Text("Spinning...")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                    
                    // Manage Options Button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showingOptionsSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "list.bullet")
                            Text("Manage Options")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(Color(hex: "00B8D4"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color(hex: "00B8D4").opacity(0.2))
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            
            // Confetti overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
            
            // Result Display - Centered between wheel and buttons
            if showResult, let option = selectedOption {
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.46)
                    
                    ResultCard(option: option, totalWeight: category.totalWeight)
                        .transition(.scale.combined(with: .opacity))
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.33)
                }
            }
        }
    }
    
    func spinWheel() {
        guard category.options.count >= 2 else { return }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        isSpinning = true
        showResult = false
        selectedOption = nil
        
        // STEP 1: Pick winner based on weights
        let totalWeight = category.totalWeight
        let random = Int.random(in: 1...totalWeight)
        
        var cumulativeWeight = 0
        var winner: WheelOption?
        
        for option in category.options {
            cumulativeWeight += option.weight
            if random <= cumulativeWeight {
                winner = option
                break
            }
        }
        
        guard let selectedWinner = winner,
              let winnerIndex = category.options.firstIndex(where: { $0.id == selectedWinner.id }) else { return }
        
        // STEP 2: Calculate winner segment's center angle
        var accumulatedAngle = 0.0
        
        for i in 0..<winnerIndex {
            let segmentSize = (Double(category.options[i].weight) / Double(totalWeight)) * 360.0
            accumulatedAngle += segmentSize
        }
        
        let winnerSegmentSize = (Double(selectedWinner.weight) / Double(totalWeight)) * 360.0
        let winnerCenterAngle = accumulatedAngle + (winnerSegmentSize / 2.0)
        
        // STEP 3: Calculate final rotation
        // RESET wheel rotation to 0 before each spin to avoid accumulation errors
        rotation = 0
        
        // SIMPLEST APPROACH:
        // Wheel segments drawn counter-clockwise starting from 0° (right)
        // Pointer is at 270° (top)
        // rotationEffect rotates CLOCKWISE (positive = clockwise)
        // To bring winnerCenter to 270°, we rotate CLOCKWISE by: (360 - winnerCenter + 270) mod 360
        
        let pointerPosition = 270.0
        let rotationNeeded = (360.0 - winnerCenterAngle + pointerPosition).truncatingRemainder(dividingBy: 360.0)
        
        let fullSpins = Double.random(in: 5...7) * 360.0
        let finalRotation = rotationNeeded + fullSpins
        
        print("==================================================")
        print("🎯 Winner: \(selectedWinner.name) (Index \(winnerIndex))")
        print("� Winner center: \(winnerCenterAngle)° → rotating to 270°")
        print("🎪 Rotation needed: \(rotationNeeded)° + \(fullSpins)° spins")
        print("✅ Final rotation: \(finalRotation)°")
        print("🧮 Total weight: \(totalWeight), Random: \(random)")
        print("==================================================")
        
        // STEP 4: Animate!
        withAnimation(.timingCurve(0.17, 0.67, 0.3, 1.0, duration: 4.0)) {
            rotation = finalRotation
        }
        
        // STEP 5: Show result after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            // CRITICAL FIX: Instead of using the calculated winner,
            // READ what the pointer is actually pointing at after rotation!
            let finalAngle = finalRotation.truncatingRemainder(dividingBy: 360.0)
            
            // Pointer is at 270° (top). After rotation, where is each segment?
            // Each segment's position after rotation = (originalPosition + rotation) mod 360
            // We need to find which segment is at 270° now
            
            var actualWinner: WheelOption?
            for (index, option) in category.options.enumerated() {
                let (segStart, segEnd) = calculateSegmentPosition(index: index, totalWeight: totalWeight)
                
                // After rotation, segment's new position
                let newStart = (segStart + finalAngle).truncatingRemainder(dividingBy: 360.0)
                let newEnd = (segEnd + finalAngle).truncatingRemainder(dividingBy: 360.0)
                
                // Check if pointer (270°) is within this segment
                if newStart < newEnd {
                    // Normal case: segment doesn't wrap around 0°
                    if 270.0 >= newStart && 270.0 <= newEnd {
                        actualWinner = option
                        break
                    }
                } else {
                    // Segment wraps around 0° (e.g., 350° to 10°)
                    if 270.0 >= newStart || 270.0 <= newEnd {
                        actualWinner = option
                        break
                    }
                }
            }
            
            selectedOption = actualWinner ?? selectedWinner // Fallback to calculated winner
            
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showResult = true
            }
            
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showConfetti = false
                }
            }
            
            isSpinning = false
        }
    }
    
    private func calculateSegmentPosition(index: Int, totalWeight: Int) -> (Double, Double) {
        var startAngle = 0.0
        for i in 0..<index {
            let segmentSize = (Double(category.options[i].weight) / Double(totalWeight)) * 360.0
            startAngle += segmentSize
        }
        let segmentSize = (Double(category.options[index].weight) / Double(totalWeight)) * 360.0
        return (startAngle, startAngle + segmentSize)
    }
}

// MARK: - Spinning Wheel Component
struct SpinningWheel: View {
    let options: [WheelOption]
    let rotation: Double
    
    // Vibrant colors with good contrast
    let colors: [Color] = [
        Color(hex: "7B68EE"),  // Purple
        Color(hex: "20B2AA"),  // Turquoise
        Color(hex: "FF1493"),  // Deep Pink
        Color(hex: "32CD32"),  // Lime Green
        Color(hex: "FFD700"),  // Gold
        Color(hex: "FF6347"),  // Tomato Red
        Color(hex: "00CED1"),  // Dark Turquoise
        Color(hex: "FF69B4")   // Hot Pink
    ]
    
    private var totalWeight: Int {
        options.reduce(0) { $0 + $1.weight }
    }
    
    var body: some View {
        ZStack {
            // Draw each segment
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                let segmentData = calculateSegmentAngles(for: index)
                
                WheelSegment(
                    option: option,
                    startAngle: segmentData.start,
                    endAngle: segmentData.end,
                    color: colors[index % colors.count]
                )
            }
            
            // Center circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.5), radius: 10)
        }
        .rotationEffect(.degrees(rotation))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private func calculateSegmentAngles(for index: Int) -> (start: Double, end: Double) {
        var startAngle = 0.0
        
        // Calculate start angle by summing previous segments
        for i in 0..<index {
            let segmentSize = (Double(options[i].weight) / Double(totalWeight)) * 360.0
            startAngle += segmentSize
        }
        
        // Calculate end angle
        let currentSegmentSize = (Double(options[index].weight) / Double(totalWeight)) * 360.0
        let endAngle = startAngle + currentSegmentSize
        
        return (startAngle, endAngle)
    }
}

// MARK: - Wheel Segment
struct WheelSegment: View {
    let option: WheelOption
    let startAngle: Double
    let endAngle: Double
    let color: Color
    
    private var midAngle: Double {
        (startAngle + endAngle) / 2.0
    }
    
    var body: some View {
        ZStack {
            // Colored segment
            SegmentShape(startAngle: startAngle, endAngle: endAngle)
                .fill(color)
            
            // White border
            SegmentShape(startAngle: startAngle, endAngle: endAngle)
                .stroke(Color.white.opacity(0.4), lineWidth: 2)
            
            // Text label - adjusted for standard coordinate system
            Text(option.name)
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3, x: 0, y: 2)
                .shadow(color: .black, radius: 6, x: 0, y: 3)
                .shadow(color: .black, radius: 9, x: 0, y: 4)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(width: 100)
                .offset(y: -100) // Position text away from center
                .rotationEffect(.degrees(midAngle + 90)) // +90 to make text point outward correctly
        }
    }
}

// MARK: - Segment Shape (Custom Path)
struct SegmentShape: Shape {
    let startAngle: Double
    let endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Start from center
        path.move(to: center)
        
        // Draw arc - counter-clockwise (false)
        // 0° = right (3 o'clock), 90° = bottom (6 o'clock), etc.
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        
        // Close path back to center
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Result Card
struct ResultCard: View {
    let option: WheelOption
    let totalWeight: Int
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: 32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FDCB6E"), Color(hex: "FF6B9D")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Winner!")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
            
            Text(option.name)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text("\(Int(option.percentage(totalWeight: totalWeight)))% chance")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
        .background(
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
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: Color(hex: "FF6B9D").opacity(0.3), radius: 30, x: 0, y: 15)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        WheelSpinnerView(category: Category(
            name: "Test Wheel",
            options: [
                WheelOption(name: "Option 1", weight: 3),
                WheelOption(name: "Option 2", weight: 2),
                WheelOption(name: "Option 3", weight: 1)
            ]
        ))
        .environmentObject(CategoryViewModel())
    }
}
