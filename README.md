# SpinChoice 🎡

A beautiful, modern SwiftUI iOS application for making decisions with customizable spinning wheels.

## Features

### ✨ Core Functionality
- **Multiple Categories**: Create unlimited wheel categories (e.g., "Food Wheel", "Game Night", "Movie Choice")
- **Custom Options**: Add/remove options with custom weights/votes
- **Smart Percentages**: Automatically calculates probabilities based on votes
- **Animated Spinning**: Physics-based wheel animation with realistic deceleration
- **Haptic Feedback**: Premium feel with haptic feedback throughout the app
- **Data Persistence**: All data saved locally using UserDefaults

### 🎨 Design
- **Gen Z Aesthetic**: Vibrant purple/blue/pink color scheme with gradients
- **Glassmorphism**: Beautiful frosted glass effects on cards
- **Dark Mode**: Optimized for dark theme with stunning visuals
- **Typography**: SF Pro Rounded for a friendly, modern look
- **Smooth Animations**: Every interaction feels polished and premium

### 🎬 Animations
- Wheel spin with realistic physics and deceleration
- Confetti celebration on winning result
- Smooth screen transitions with spring animations
- Button press effects (scale down to 0.95x)
- Staggered card animations on load
- Swipe-to-delete with smooth transitions
- Number counter animations for percentage changes
- Floating bounce effect for empty states

## Project Structure

```
randomApp/
├── SpinChoiceApp.swift          # App entry point
├── ContentView.swift             # Main content view
├── Models/
│   ├── Category.swift           # Category data model
│   └── WheelOption.swift        # Option data model
├── ViewModels/
│   └── CategoryViewModel.swift  # MVVM view model
├── Views/
│   ├── CategoriesListView.swift       # Main categories grid
│   ├── AddCategoryView.swift          # Create new category
│   ├── AddOptionView.swift            # Add option with votes
│   ├── WheelSpinnerView.swift         # Spinning wheel view
│   ├── OptionsManagementView.swift    # Manage options
│   ├── EmptyStateView.swift           # Empty state component
│   └── ConfettiView.swift             # Confetti animation
├── Managers/
│   └── PersistenceManager.swift # Data persistence
├── Styles/
│   └── ScaleButtonStyle.swift   # Reusable button style
├── Extensions/
│   └── Color+Hex.swift          # Hex color support
└── Info.plist
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- SwiftUI

## How to Build

### Option 1: Using Xcode (Recommended)

1. **Open Xcode** and create a new iOS App project:
   - Choose "App" template
   - Product Name: `SpinChoice`
   - Interface: SwiftUI
   - Life Cycle: SwiftUI App
   - Language: Swift
   - Minimum Deployment: iOS 15.0

2. **Replace/Add files** from this repository into your Xcode project

3. **Build and Run** (⌘+R)

### Option 2: Manual Setup

If you want to quickly test this, you'll need to:

1. Create an Xcode project
2. Copy all the Swift files into the appropriate groups
3. Ensure the file structure matches the project structure above
4. Build and run on simulator or device

## Usage

### Creating Your First Wheel

1. Launch the app
2. Tap the **"+"** button
3. Enter a category name (e.g., "Friday Night Games")
4. Add options by tapping **"Add"**
5. For each option:
   - Enter name (e.g., "League of Legends")
   - Set number of votes/weight
6. Tap **"Create"** when you have at least 2 options

### Spinning the Wheel

1. Tap a category card from the main screen
2. Review your options and their percentages
3. Tap **"Spin the Wheel"** button
4. Watch the beautiful animation! 🎉
5. See the result with confetti celebration
6. Tap **"Spin Again"** for another try

### Managing Options

1. In the wheel view, tap **"Manage Options"**
2. See all options with their percentages
3. Swipe left on any option to delete
4. Tap **"+"** to add more options
5. Changes are saved automatically

## Color Palette

The app uses a carefully crafted Gen Z-inspired color scheme:

- **Primary Purple**: `#6C5CE7` - Main brand color
- **Cyan**: `#00B8D4` - Secondary accent
- **Pink**: `#FF6B9D` - Playful accent
- **Mint Green**: `#00D9A3` - Success states
- **Yellow**: `#FDCB6E` - Warning/winner
- **Dark Background**: `#1A1A2E` - Main dark background
- **Secondary Dark**: `#16213E` - Gradient background

## Technical Highlights

- **MVVM Architecture**: Clean separation of concerns
- **SwiftUI Native**: 100% SwiftUI, no UIKit
- **Codable Models**: Easy JSON encoding/decoding for persistence
- **EnvironmentObject**: Efficient state management
- **Custom Shapes**: Hand-drawn wheel segments using Path
- **Spring Animations**: Natural, physics-based animations
- **Haptic Feedback**: UIFeedbackGenerator integration
- **Gradient Everywhere**: Beautiful gradient overlays

## Animations Breakdown

### Wheel Spin Animation
```swift
.timingCurve(0.17, 0.67, 0.3, 1.0, duration: 4.0)
```
- 4-second duration
- Custom bezier curve for realistic deceleration
- Multiple full rotations (5-7 spins)
- Haptic feedback on start and result

### Card Animations
```swift
.spring(response: 0.6, dampingFraction: 0.8)
```
- Staggered appearance with 0.1s delays
- Fade + slide from bottom
- Scale effect on press (0.95x)

### Confetti Animation
- 50 particles with random colors
- Random trajectories and rotations
- 1.5-3 second duration with fade out
- Multiple shapes (circle, rectangle, rounded rectangle)

## Future Enhancements

Potential features for future versions:

- [ ] Edit existing categories and options
- [ ] Share wheel results with friends
- [ ] History of past spins
- [ ] Custom colors for each wheel
- [ ] Sound effects
- [ ] iCloud sync across devices
- [ ] Widgets for quick access
- [ ] Apple Watch companion app

## License

This is a sample project for educational purposes.


**Made for those who can't decide what to eat, play, or watch! Let the wheel decide your fate! 🎡✨**
