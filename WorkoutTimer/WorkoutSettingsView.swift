//
//  WorkoutSettingsView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 6/17/25.
//

import SwiftUI

struct WorkoutSettingsView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Text("WORK")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                Text(timeString(from: workoutModel.workTime))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .cornerRadius(12)
                    .frame(width: 150)
                    .fixedSize()
            }
            HStack {
                Text("REST")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                Text(timeString(from: workoutModel.restTime))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(12)
                    .frame(width: 150)
                    .fixedSize()
            }
        }
        .padding()
        .frame(width: 320, height: 240)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
} 