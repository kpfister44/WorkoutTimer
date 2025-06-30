# WorkoutTimer iOS App - Development Guide

## Project Overview
A clean, intuitive iOS interval training app built with SwiftUI. Features customizable work/rest cycles, round-based workouts, favorites system, and audio/haptic feedback.

## Architecture
- **Pattern**: MVVM with SwiftUI
- **iOS Target**: 16.0+
- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI with NavigationStack

## Project Structure

```
WorkoutTimer/
├── Assets.xcassets/          # App icons and color assets
├── Managers/                 # Singleton service classes
│   ├── FavoriteWorkoutsManager.swift
│   ├── HapticManager.swift
│   └── SoundManager.swift
├── Models/                   # Data models and state management
│   ├── FavoriteWorkout.swift
│   └── WorkoutModel.swift
├── Sounds/                   # Audio assets
│   ├── prep_start.mp3
│   ├── rest_start.mp3
│   ├── work_start.mp3
│   └── workout_complete.mp3
├── Views/                    # SwiftUI view components
│   ├── ContentView.swift
│   ├── ControlsView.swift
│   ├── FavoritesView.swift
│   ├── PrivacyPolicyView.swift
│   ├── RoundsPickerView.swift
│   ├── SettingsView.swift
│   ├── TimerDisplayView.swift
│   ├── WorkoutSettingsView.swift
│   └── WorkoutStatusView.swift
├── WorkoutTimer.entitlements
└── WorkoutTimerApp.swift     # App entry point
```

## Core Components

### WorkoutModel.swift (Central State Management)
**Key Properties:**
- `rounds: Int` - Number of workout rounds (1-60) ✅ **UPDATED**
- `workTime: Int` - Work interval duration in seconds
- `restTime: Int` - Rest interval duration in seconds
- `prepTime: Int` - Preparation countdown duration in seconds (default: 10)
- `currentRound: Int` - Current round progress
- `timeRemaining: Int` - Countdown timer value
- `isWorking: Bool` - Current phase (work vs rest)
- `isPreparing: Bool` - Preparation phase state
- `isActive: Bool` - Workout running state

**Key Methods:**
- `startWorkout()` - Begins workout with preparation phase + prevents screen sleep ✅ **UPDATED**
- `pauseWorkout()` - Pauses active workout
- `resumeWorkout()` - Resumes paused workout (skips preparation)
- `resetWorkout()` - Returns to initial state + re-enables screen sleep ✅ **UPDATED**

**Screen Wake Prevention:** Uses `UIApplication.shared.isIdleTimerDisabled` to prevent screen sleep during workouts ✅ **ADDED**

### SoundManager.swift (Audio System)
**Audio Session:** `.ambient` with `.mixWithOthers` (music-friendly)
**Sound Events:**
- `prepStart` → `prep_start.mp3`
- `workStart` → `work_start.mp3`
- `restStart` → `rest_start.mp3` 
- `workoutComplete` → `workout_complete.mp3`
- `finalRound` → `final_round.mp3` ✅ **ADDED**
- `lastThreeSeconds` → `last_three_seconds.mp3` ✅ **ADDED**

**File Location:** `/WorkoutTimer/Sounds/` directory

### Key Views

#### ContentView.swift
- **Role**: Main coordinator and state container
- **Contains**: `@StateObject var workoutModel = WorkoutModel()`
- **Navigation**: Handles all view transitions and sheet presentations
- **Battery Warning**: One-time alert using `@AppStorage("hasShownBatteryWarning")` to inform users about screen wake behavior ✅ **ADDED**

#### ControlsView.swift
- **Role**: Workout control buttons (start/pause/resume/reset)
- **Key Code**: Lines 32-40 contain START button logic
- **State Logic**: Conditional button display based on workout state

#### TimerDisplayView.swift
- **Role**: Circular progress indicator and time display
- **Features**: Animated countdown, MM:SS format, color-coded phases (blue=prep, green=work, orange=rest)

#### WorkoutSettingsView.swift
- **Role**: Configure prep/work/rest time intervals
- **UI**: Time picker sheets with wheel selectors and quick-select buttons
- **Range**: Currently supports up to 59 minutes per interval
- **Colors**: Blue (prep), Green (work), Orange (rest)
- **Recent Fix**: Resolved SwiftUI closure capture bug causing wrong picker to appear on first app launch ✅ **FIXED**

#### RoundsPickerView.swift
- **Role**: Select number of workout rounds
- **Current Limit**: 60 rounds maximum ✅ **UPDATED**
- **UI**: Increment/decrement buttons with numeric display

## Data Persistence
- **Method**: UserDefaults with JSON encoding
- **Scope**: Favorite workouts only
- **Manager**: `FavoriteWorkoutsManager.swift`
- **FavoriteWorkout Model**: Includes prepTime property with backward compatibility

## Current Issues (GitHub Issues Created)

### ✅ Issue #1: Add Preparation Timer Feature (COMPLETED)
- **Status**: Implemented and merged (commit 86326fd)
- **Features**: 10-second default preparation countdown with blue theme
- **Implementation**: Full preparation phase with configurable timing (5-30s)
- **Files Modified**: WorkoutModel, SoundManager, TimerDisplayView, WorkoutSettingsView, etc.

### ✅ Issue #2: Fix Timer Freezing When iPhone Screen Goes to Sleep (COMPLETED)
- **Status**: Implemented and merged (PR #8)
- **Problem**: Timer stopped when iPhone screen went to sleep
- **Solution**: Screen wake prevention using `UIApplication.shared.isIdleTimerDisabled`
- **Implementation**: Prevents screen sleep during workouts, re-enables when workout ends
- **User Experience**: One-time battery warning alert with `@AppStorage` persistence
- **Files Modified**: WorkoutModel.swift (UIKit import + screen wake logic), ContentView.swift (battery warning UI)

### ✅ Issue #3: Increase Maximum Rounds from 20 to 60 (COMPLETED)
- **Status**: Implemented and merged (PR #5)
- **Change**: `RoundsPickerView.swift:35` - `if rounds < 20` → `if rounds < 60`
- **Impact**: Support longer workout sessions up to 60 rounds

### ✅ Issue #4: Add Final Round Audio and Countdown Chimes (COMPLETED)
- **Status**: Implemented and merged (PR #6)
- **Audio Files**: `final_round.mp3`, `last_three_seconds.mp3` (both added)
- **Features**: "Final Round" announcement + 3-second countdown during work/rest
- **Integration**: Expanded `SoundManager.swift` SoundEvent enum with new audio cues

### ✅ Prep Picker Bug: SwiftUI Sheet Timing Issue (COMPLETED)
- **Status**: Fixed and merged (PR #7)
- **Problem**: Prep time picker showed work sheet on first app launch
- **Root Cause**: SwiftUI `sheet(isPresented:)` closure capture timing bug
- **Solution**: Replaced with `sheet(item:)` pattern using `SheetData` struct
- **Impact**: Reliable picker behavior regardless of app launch timing

## Development Guidelines

### Audio Implementation
- **Format**: MP3 files in `/WorkoutTimer/Sounds/`
- **Session**: Maintain `.ambient` category for music compatibility
- **Integration**: Add to `SoundEvent` enum, update `playSound(for:)` calls

### Timer Implementation
- **Current**: Combine-based `Timer.publish(every: 1)` with screen wake prevention ✅ **UPDATED**
- **Screen Sleep Solution**: Uses `UIApplication.shared.isIdleTimerDisabled` to prevent screen sleep during workouts
- **Precision**: 1-second intervals with state transitions
- **Background Issue**: Resolved by preventing screen sleep instead of background processing ✅ **RESOLVED**

### State Management
- **Pattern**: `@StateObject` in ContentView, `@ObservedObject` in child views
- **Updates**: Use `@Published` properties for reactive UI
- **Navigation**: Sheet presentations for settings, NavigationStack for main flow

### Testing Commands
```bash
# No specific test commands found in codebase
# Test manually in Xcode Simulator and physical device
# Focus on timer accuracy, audio functionality, state persistence
```

### Build Commands
```bash
# Standard Xcode build process
# No custom build scripts or package managers detected
# Build and run directly in Xcode
```

## Repository Information
- **GitHub**: https://github.com/kpfister44/WorkoutTimer
- **Branch**: main
- **Issues**: All major issues completed ✅ **UPDATED**
- **GitHub CLI**: Configured with authentication token for automated PR creation
- **Latest Commit**: 47d47fa (Fixed timer freezing when screen sleeps) ✅ **UPDATED**

## Completed Features ✅
1. ✅ **Preparation timer (Issue #1)** - 10-second configurable prep phase with blue theme
2. ✅ **Screen sleep prevention (Issue #2)** - Timer continues running when screen would sleep
3. ✅ **Extended rounds limit (Issue #3)** - Support up to 60 workout rounds  
4. ✅ **Enhanced audio cues (Issue #4)** - Final round announcements + 3-second countdown chimes
5. ✅ **SwiftUI picker bug fix** - Reliable time picker behavior on app launch

**Current Status**: All major issues resolved. App ready for production use.

## Future Enhancement Ideas
- Custom workout templates and advanced scheduling
- Apple Watch companion app integration
- Detailed workout history and analytics
- Social sharing and workout challenges
- Integration with Apple Health/HealthKit
- Custom sound/music integration
- Advanced interval patterns (pyramid, tabata variations)

## Key Implementation Patterns Established
- **Screen Wake Prevention**: `UIApplication.shared.isIdleTimerDisabled` pattern for timer-based features
- **User Consent UI**: `@AppStorage` with one-time alerts for system behavior changes
- **Audio Integration**: Ambient session with custom sound events for workout phases
- **SwiftUI Navigation**: Sheet-based settings with NavigationStack for main flow
- **State Management**: Centralized `@StateObject` WorkoutModel with reactive `@Published` properties

Each completed feature demonstrates best practices for iOS development and provides a foundation for future enhancements.
