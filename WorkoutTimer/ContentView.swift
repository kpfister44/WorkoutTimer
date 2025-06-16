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
            VStack(spacing: 30) {
                // Add padding at the top to create space below the navigation title
                Spacer()
                    .frame(height: 10)
                
                // Timer display
                TimerDisplayView(workoutModel: workoutModel)
                    .padding(.top, 10)
                
                // Workout settings
                if !workoutModel.isActive && workoutModel.currentRound == 0 {
                    WorkoutSettingsView(workoutModel: workoutModel)
                } else {
                    // Workout status
                    WorkoutStatusView(workoutModel: workoutModel)
                }
                
                // Controls
                ControlsView(workoutModel: workoutModel)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Workout Timer")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Workout Timer")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(workoutModel: workoutModel)) {
                        Image(systemName: "star.fill")
                    }
                    .disabled(workoutModel.isActive)
                }
                #else
                ToolbarItem {
                    NavigationLink(destination: FavoritesView(workoutModel: workoutModel)) {
                        Image(systemName: "star.fill")
                    }
                    .disabled(workoutModel.isActive)
                }
                #endif
            }
        }
    }
}

struct TimerDisplayView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        ZStack {
            // Progress ring
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Progress indicator
            Circle()
                .trim(from: 0.0, to: progressFraction)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(workoutModel.isWorking ? Color.green : Color.orange)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progressFraction)
            
            // Time display
            VStack {
                Text(timeString(from: workoutModel.timeRemaining))
                    .font(.system(size: 70, weight: .bold, design: .monospaced))
                
                if workoutModel.isActive {
                    Text(workoutModel.isWorking ? "WORK" : "REST")
                        .font(.title)
                        .foregroundColor(workoutModel.isWorking ? .green : .orange)
                        .fontWeight(.bold)
                }
            }
        }
        .frame(width: 300, height: 300)
    }
    
    private var progressFraction: CGFloat {
        if workoutModel.timeRemaining == 0 { return 0 }
        
        let totalInterval = workoutModel.isWorking ? workoutModel.workTime : workoutModel.restTime
        return CGFloat(workoutModel.timeRemaining) / CGFloat(totalInterval)
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct WorkoutSettingsView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Workout Settings")
                .font(.headline)
            
            HStack {
                Text("Rounds:")
                Spacer()
                Text("\(workoutModel.rounds) rds")
                    .frame(width: 80, alignment: .trailing)
                Stepper("\(workoutModel.rounds)", value: $workoutModel.rounds, in: 1...20)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Work:")
                Spacer()
                Text("\(workoutModel.workTime) sec")
                    .frame(width: 80, alignment: .trailing)
                Stepper("", value: $workoutModel.workTime, in: 5...300, step: 5)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Rest:")
                Spacer()
                Text("\(workoutModel.restTime) sec")
                    .frame(width: 80, alignment: .trailing)
                Stepper("", value: $workoutModel.restTime, in: 5...300, step: 5)
                    .frame(width: 100)
            }
            
            Text("Total Time: \(formatTotalTime(workoutModel.totalTime))")
                .font(.subheadline)
                .padding(.top)
        }
        .padding()
        .frame(width: 350)
        #if os(iOS)
        .background(Color(UIColor.systemGray6))
        #else
        .background(Color.gray.opacity(0.2))
        #endif
        .cornerRadius(10)
    }
    
    private func formatTotalTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(remainingSeconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

struct WorkoutStatusView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Round information
            Text("Round \(workoutModel.currentRound) of \(workoutModel.rounds)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Work and Rest intervals
            HStack(spacing: 30) {
                // Work section
                VStack(spacing: 8) {
                    Text("WORK")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.workTime)")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    
                    Text("seconds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Rest section
                VStack(spacing: 8) {
                    Text("REST")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.restTime)")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                    
                    Text("seconds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(20)
        .frame(width: 300)
    }
}

struct ControlsView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        HStack(spacing: 30) {
            if workoutModel.isActive {
                // Pause button
                Button(action: {
                    workoutModel.pauseWorkout()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                }
            } else if workoutModel.currentRound > 0 {
                // Resume button
                Button(action: {
                    workoutModel.resumeWorkout()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            } else {
                // Start button
                Button(action: {
                    workoutModel.startWorkout()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            }
            
            // Reset button
            Button(action: {
                workoutModel.resetWorkout()
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    ContentView()
}
