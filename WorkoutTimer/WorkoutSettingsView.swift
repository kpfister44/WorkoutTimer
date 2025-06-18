//
//  WorkoutSettingsView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 6/17/25.
//

import SwiftUI

struct WorkoutSettingsView: View {
    @ObservedObject var workoutModel: WorkoutModel
    
    @State private var showingPicker: Bool = false
    @State private var pickerType: PickerType = .work
    
    enum PickerType {
        case work, rest
    }
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Text("WORK")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                Button(action: {
                    pickerType = .work
                    showingPicker = true
                }) {
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
            }
            HStack {
                Text("REST")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                Button(action: {
                    pickerType = .rest
                    showingPicker = true
                }) {
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
        }
        .padding()
        .frame(width: 320, height: 240)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .sheet(isPresented: $showingPicker) {
            TimePickerSheet(
                title: pickerType == .work ? "Work" : "Rest",
                color: pickerType == .work ? .green : .orange,
                initialSeconds: pickerType == .work ? workoutModel.workTime : workoutModel.restTime,
                onDone: { newSeconds in
                    if pickerType == .work {
                        workoutModel.workTime = newSeconds
                    } else {
                        workoutModel.restTime = newSeconds
                    }
                    showingPicker = false
                },
                onCancel: { showingPicker = false }
            )
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct TimePickerSheet: View {
    let title: String
    let color: Color
    let initialSeconds: Int
    let onDone: (Int) -> Void
    let onCancel: () -> Void

    @State private var minutes: Int
    @State private var seconds: Int

    private let pickerWidth: CGFloat = UIScreen.main.bounds.width - 36 // 18pt padding each side

    init(title: String, color: Color, initialSeconds: Int, onDone: @escaping (Int) -> Void, onCancel: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.initialSeconds = initialSeconds
        self.onDone = onDone
        self.onCancel = onCancel
        _minutes = State(initialValue: initialSeconds / 60)
        _seconds = State(initialValue: initialSeconds % 60)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Colored box with label and time
            VStack(spacing: 10) {
                Text(title.uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                Text(String(format: "%02d:%02d", minutes, seconds))
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .frame(width: pickerWidth, height: 220)
            .background(color)
            .cornerRadius(24)

            // Quick-pick buttons
            HStack(spacing: 12) {
                ForEach([10, 15, 20], id: \.self) { quick in
                    Button(action: {
                        minutes = quick / 60
                        seconds = quick % 60
                    }) {
                        Text(String(format: "%02d:%02d", quick / 60, quick % 60))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color(.systemGray3))
                            .cornerRadius(10)
                    }
                }
            }
            .frame(width: pickerWidth)
            .padding(.top, 18)
            .padding(.bottom, 10)

            // Wheel pickers
            HStack(spacing: 0) {
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { Text("\($0) mins") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 110)
                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) { Text("\($0) secs") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 110)
            }
            .frame(width: pickerWidth)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.vertical, 10)

            // Done button
            Button(action: {
                onDone(minutes * 60 + seconds)
            }) {
                Text("DONE")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: pickerWidth, height: 72)
            .background(Color(.systemGray4))
            .cornerRadius(12)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(.systemBackground))
    }
} 