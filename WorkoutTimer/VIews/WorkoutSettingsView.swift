//
//  WorkoutSettingsView.swift
//  WorkoutTimer
//
//  Created by Kyle Pfister on 6/17/25.
//

import SwiftUI

/// View for configuring work and rest time intervals for workouts.
struct WorkoutSettingsView: View {
    /// Reference to the workout model for updating time settings.
    @ObservedObject var workoutModel: WorkoutModel
    
    /// Controls the display of the time picker sheet.
    @State private var showingPicker: Bool = false
    /// Determines which time setting is being edited (work or rest).
    @State private var pickerType: PickerType = .work
    
    /// Enum to distinguish between work, rest, and prep time picker types.
    enum PickerType {
        case work, rest, prep
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Preparation time setting row.
            HStack {
                Text("PREP")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    pickerType = .prep
                    showingPicker = true
                }) {
                    Text(timeString(from: workoutModel.prepTime))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .frame(width: 150)
                        .fixedSize()
                }
            }
            
            // Work time setting row.
            HStack {
                Text("WORK")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    pickerType = .work
                    showingPicker = true
                }) {
                    Text(timeString(from: workoutModel.workTime))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(12)
                        .frame(width: 150)
                        .fixedSize()
                }
            }
            
            // Rest time setting row.
            HStack {
                Text("REST")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    pickerType = .rest
                    showingPicker = true
                }) {
                    Text(timeString(from: workoutModel.restTime))
                        .font(.title)
                        .fontWeight(.bold)
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
        .frame(width: 320, height: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .sheet(isPresented: $showingPicker) {
            TimePickerSheet(
                title: pickerTitle,
                color: pickerColor,
                initialSeconds: pickerInitialSeconds,
                onDone: { newSeconds in
                    switch pickerType {
                    case .prep:
                        workoutModel.prepTime = newSeconds
                    case .work:
                        workoutModel.workTime = newSeconds
                    case .rest:
                        workoutModel.restTime = newSeconds
                    }
                    showingPicker = false
                },
                onCancel: { showingPicker = false }
            )
        }
    }
    
    /// Computed property for the picker title based on picker type.
    private var pickerTitle: String {
        switch pickerType {
        case .prep: return "Prep"
        case .work: return "Work"
        case .rest: return "Rest"
        }
    }
    
    /// Computed property for the picker color based on picker type.
    private var pickerColor: Color {
        switch pickerType {
        case .prep: return .blue
        case .work: return .green
        case .rest: return .orange
        }
    }
    
    /// Computed property for the picker initial seconds based on picker type.
    private var pickerInitialSeconds: Int {
        switch pickerType {
        case .prep: return workoutModel.prepTime
        case .work: return workoutModel.workTime
        case .rest: return workoutModel.restTime
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

/// Sheet view for picking time intervals with wheel pickers and quick-select buttons.
struct TimePickerSheet: View {
    /// Title to display at the top of the picker.
    let title: String
    /// Color theme for the picker header.
    let color: Color
    /// Initial time value in seconds.
    let initialSeconds: Int
    /// Callback when time selection is confirmed.
    let onDone: (Int) -> Void
    /// Callback when time selection is cancelled.
    let onCancel: () -> Void

    /// Selected minutes value.
    @State private var minutes: Int
    /// Selected seconds value.
    @State private var seconds: Int

    /// Width of the picker components, accounting for screen padding.
    private let pickerWidth: CGFloat = UIScreen.main.bounds.width - 36 // 18pt padding each side

    /// Initializes the time picker with the given parameters.
    /// - Parameters:
    ///   - title: The title to display.
    ///   - color: The color theme for the header.
    ///   - initialSeconds: The initial time value in seconds.
    ///   - onDone: Callback for when time selection is confirmed.
    ///   - onCancel: Callback for when time selection is cancelled.
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
            // Colored header box with title and current time display.
            VStack(spacing: 10) {
                Text(title.uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(String(format: "%02d:%02d", minutes, seconds))
                    .font(.system(.largeTitle, design: .monospaced)) 
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(width: pickerWidth, height: 220)
            .background(color)
            .cornerRadius(24)

            // Quick-select buttons for common time intervals.
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

            // Wheel pickers for minutes and seconds selection.
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

            // Done button to confirm time selection.
            Button(action: {
                onDone(minutes * 60 + seconds)
            }) {
                Text("DONE")
                    .font(.title)
                    .fontWeight(.bold)
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