//
//  ContentView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutModel = WorkoutModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { 
                // Custom Header using a ZStack
                ZStack {
                    // This HStack will center the title perfectly
                    HStack {
                        Spacer()
                        Text("WORKOUT TIMER")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    // This HStack overlays the button on the right when the workout is not active
                    HStack {
                        Spacer()
                        if !workoutModel.isActive {
                            NavigationLink(destination: FavoritesView(workoutModel: workoutModel)) {
                                Image(systemName: "line.3.horizontal")
                                    .font(.title) 
                                    .foregroundColor(.blue)
                            }
                        }
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
                    Spacer()
                    RoundsPickerView(rounds: $workoutModel.rounds)
                        .padding(.bottom, 24)
                    WorkoutSettingsView(workoutModel: workoutModel)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                    Spacer()
                    VStack(spacing: 8) {
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
                    .padding()
                }
            }
        }
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
