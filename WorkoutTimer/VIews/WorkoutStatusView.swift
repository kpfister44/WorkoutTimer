import SwiftUI

/// View displaying current workout status including round progress and time intervals.
struct WorkoutStatusView: View {
    /// Reference to the workout model for accessing current workout state and settings.
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Current round progress display.
            Text(roundStatusText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Work, Rest, and Prep interval information cards.
            HStack(spacing: 20) {
                // Preparation interval card with blue theme.
                VStack(spacing: 8) {
                    Text("PREP")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.prepTime)")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("SECONDS")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Work interval card with green theme.
                VStack(spacing: 8) {
                    Text("WORK")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.workTime)")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("SECONDS")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                // Rest interval card with orange theme.
                VStack(spacing: 8) {
                    Text("REST")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .tracking(1.5)
                    
                    Text("\(workoutModel.restTime)")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("SECONDS")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding(20)
    }
    
    /// Computed property for the round status text based on current phase.
    private var roundStatusText: String {
        if workoutModel.isPreparing {
            return "GET READY"
        } else if workoutModel.currentRound > 0 {
            return "ROUND \(workoutModel.currentRound) OF \(workoutModel.rounds)"
        } else {
            return "ROUND 0 OF \(workoutModel.rounds)"
        }
    }
} 
