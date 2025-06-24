//
//  ContentView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutModel = WorkoutModel()
    @State private var showingSettings = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) { 
                HStack {
                    // Left icon: Hamburger menu
                    NavigationLink(destination: FavoritesView(workoutModel: workoutModel)) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    // Centered title
                    Text("WORKOUT TIMER")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    // Right icon: Settings
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                if workoutModel.isActive || workoutModel.currentRound > 0 {
                    // Timer display only during an active workout
                    Spacer()
                    TimerDisplayView(workoutModel: workoutModel)
                    WorkoutStatusView(workoutModel: workoutModel)
                    ControlsView(workoutModel: workoutModel)
                    Spacer()
                } else {
                    VStack(spacing: 24) {
                        RoundsPickerView(rounds: $workoutModel.rounds)
                        WorkoutSettingsView(workoutModel: workoutModel)
                        Spacer()
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
                        Text("TOTAL TIME: \(formatTotalTime(workoutModel.totalTime))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func formatTotalTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    ContentView()
}
