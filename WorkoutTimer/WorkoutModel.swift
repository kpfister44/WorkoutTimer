import Foundation
import Combine

class WorkoutModel: ObservableObject {
    @Published var rounds: Int = 3
    @Published var workTime: Int = 30 // in seconds
    @Published var restTime: Int = 10 // in seconds
    
    @Published var currentRound: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var isWorking: Bool = true
    @Published var isActive: Bool = false
    
    private var timer: AnyCancellable?
    
    var totalTime: Int {
        rounds * (workTime + restTime)
    }
    
    func startWorkout() {
        if !isActive {
            isActive = true
            currentRound = 1
            isWorking = true
            timeRemaining = workTime
            
            startTimer()
        }
    }
    
    func pauseWorkout() {
        isActive = false
        timer?.cancel()
    }
    
    func resumeWorkout() {
        isActive = true
        startTimer()
    }
    
    func resetWorkout() {
        pauseWorkout()
        currentRound = 0
        timeRemaining = 0
        isWorking = true
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    
                    // Add haptic feedback for last 3 seconds of each interval
                    if self.timeRemaining <= 3 && self.timeRemaining > 0 {
                        HapticManager.shared.impact(style: .medium)
                    }
                } else {
                    // Time's up for current interval
                    if self.isWorking {
                        // Switch to rest
                        self.isWorking = false
                        self.timeRemaining = self.restTime
                        SoundManager.shared.playSound(for: .restStart)
                        HapticManager.shared.notification(type: .success)
                    } else {
                        // End of round
                        if self.currentRound < self.rounds {
                            // Start next round
                            self.currentRound += 1
                            self.isWorking = true
                            self.timeRemaining = self.workTime
                            SoundManager.shared.playSound(for: .workStart)
                            HapticManager.shared.notification(type: .warning)
                        } else {
                            // Workout complete
                            SoundManager.shared.playSound(for: .workoutComplete)
                            HapticManager.shared.notification(type: .success)
                            self.resetWorkout()
                        }
                    }
                }
            }
    }
} 