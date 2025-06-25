//
//  ContentView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 5/9/25.
//

import SwiftUI

/// Main content view that manages the overall app interface and workout state.
struct ContentView: View {
    /// State object for managing workout data and timer functionality.
    @StateObject private var workoutModel = WorkoutModel()
    /// Controls the display of the settings sheet.
    @State private var showingSettings = false
    /// App storage for dark mode preference that persists across app launches.
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                // Conditional view based on workout state.
                if workoutModel.isActive || workoutModel.currentRound > 0 {
                    // Active workout view with timer display and controls.
                    Spacer()
                    TimerDisplayView(workoutModel: workoutModel)
                    WorkoutStatusView(workoutModel: workoutModel)
                    ControlsView(workoutModel: workoutModel)
                    Spacer()
                } else {
                    // Setup view for configuring workout before starting.
                    VStack(spacing: 24) {
                        RoundsPickerView(rounds: $workoutModel.rounds)
                        WorkoutSettingsView(workoutModel: workoutModel)
                        Spacer()
                        // Start workout button.
                        Button(action: {
                            workoutModel.startWorkout()
                        }) {
                            Text("START")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        // Total workout time display.
                        Text("TOTAL TIME: \(formatTotalTime(workoutModel.totalTime))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
            }
            .safeAreaInset(edge: .top) {
                // Custom navigation header with app title and action buttons.
                HStack {
                    // Left icon: Navigation to favorites view.
                    NavigationLink(destination: FavoritesView(workoutModel: workoutModel)) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    // Centered app title.
                    Text("WORKOUT TIMER")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    // Right icon: Settings button.
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    /// Converts total workout time from seconds to a formatted string (MM:SS).
    /// - Parameter seconds: The total workout time in seconds.
    /// - Returns: A formatted time string.
    private func formatTotalTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    ContentView()
}
