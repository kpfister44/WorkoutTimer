import SwiftUI

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
                    .font(.system(.largeTitle, design: .monospaced))
                    .fontWeight(.bold)
                
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