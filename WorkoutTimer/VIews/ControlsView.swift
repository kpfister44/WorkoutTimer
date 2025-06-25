import SwiftUI

/// View containing workout control buttons (play, pause, resume, reset).
struct ControlsView: View {
    /// Reference to the workout model for controlling workout state.
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        HStack(spacing: 30) {
            if workoutModel.isActive {
                // Pause button - shown when workout is currently running.
                Button(action: {
                    workoutModel.pauseWorkout()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                }
            } else if workoutModel.currentRound > 0 {
                // Resume button - shown when workout is paused but has progress.
                Button(action: {
                    workoutModel.resumeWorkout()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            } else {
                // Start button - shown when no workout is in progress.
                Button(action: {
                    workoutModel.startWorkout()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            }
            
            // Reset button - always visible to reset workout to initial state.
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