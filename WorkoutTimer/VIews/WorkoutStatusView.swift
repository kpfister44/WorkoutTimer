import SwiftUI

struct WorkoutStatusView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Round information
            Text("ROUND \(workoutModel.currentRound) OF \(workoutModel.rounds)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Work and Rest intervals
            HStack(spacing: 30) {
                // Work section
                VStack(spacing: 8) {
                    Text("WORK")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.workTime)")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("SECONDS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Rest section
                VStack(spacing: 8) {
                    Text("REST")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.restTime)")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("SECONDS")
                        .font(.headline)
                        .fontWeight(.bold)
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