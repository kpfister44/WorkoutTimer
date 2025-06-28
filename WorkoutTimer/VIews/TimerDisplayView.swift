import SwiftUI

/// View displaying the workout timer with a circular progress indicator and time display.
struct TimerDisplayView: View {
    /// Reference to the workout model for accessing timer state and values.
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        ZStack {
            // Background progress ring (static gray circle).
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Animated progress indicator that fills based on remaining time.
            Circle()
                .trim(from: 0.0, to: progressFraction)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progressFraction)
            
            // Central time and status display.
            VStack {
                // Time remaining display in MM:SS format.
                Text(timeString(from: workoutModel.timeRemaining))
                    .font(.system(.largeTitle, design: .monospaced))
                    .fontWeight(.bold)
                
                // Work/Rest/Prep status indicator (only shown when workout is active).
                if workoutModel.isActive {
                    Text(statusText)
                        .font(.title)
                        .foregroundColor(statusColor)
                        .fontWeight(.bold)
                }
            }
        }
        .frame(width: 300, height: 300)
    }
    
    /// Computed property that calculates the progress fraction for the circular indicator.
    private var progressFraction: CGFloat {
        if workoutModel.timeRemaining == 0 { return 0 }
        
        let totalInterval: Int
        if workoutModel.isPreparing {
            totalInterval = workoutModel.prepTime
        } else if workoutModel.isWorking {
            totalInterval = workoutModel.workTime
        } else {
            totalInterval = workoutModel.restTime
        }
        return CGFloat(workoutModel.timeRemaining) / CGFloat(totalInterval)
    }
    
    /// Computed property for the progress color based on current phase.
    private var progressColor: Color {
        if workoutModel.isPreparing {
            return .blue
        } else if workoutModel.isWorking {
            return .green
        } else {
            return .orange
        }
    }
    
    /// Computed property for the status text based on current phase.
    private var statusText: String {
        if workoutModel.isPreparing {
            return "PREPARE"
        } else if workoutModel.isWorking {
            return "WORK"
        } else {
            return "REST"
        }
    }
    
    /// Computed property for the status color based on current phase.
    private var statusColor: Color {
        if workoutModel.isPreparing {
            return .blue
        } else if workoutModel.isWorking {
            return .green
        } else {
            return .orange
        }
    }
    
    /// Converts seconds to a formatted time string (MM:SS).
    /// - Parameter seconds: The number of seconds to format.
    /// - Returns: A formatted time string.
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
} 