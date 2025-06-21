import SwiftUI

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