import Foundation
import Combine
import UIKit

class WorkoutModel: ObservableObject {
    @Published var rounds: Int = 3
    @Published var workTime: Int = 30 // in seconds
    @Published var restTime: Int = 10 // in seconds
    @Published var prepTime: Int = 10 // in seconds
    
    @Published var currentRound: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var isWorking: Bool = true
    @Published var isPreparing: Bool = false
    @Published var isActive: Bool = false
    
    private var timer: AnyCancellable?
    
    var totalTime: Int {
        rounds * (workTime + restTime)
    }
    
    func startWorkout() {
        if !isActive {
            isActive = true
            currentRound = 0
            isPreparing = true
            isWorking = false
            timeRemaining = prepTime
            
            // Prevent screen from sleeping during workout
            UIApplication.shared.isIdleTimerDisabled = true
            
            SoundManager.shared.playSound(for: .prepStart)
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
        isPreparing = false
        
        // Re-enable screen sleep when workout ends
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    
                    // Add haptic feedback and audio for last 3 seconds of work/rest intervals
                    if self.timeRemaining == 3 && !self.isPreparing {
                        SoundManager.shared.playSound(for: .lastThreeSeconds)
                    }
                    if self.timeRemaining <= 3 && self.timeRemaining > 0 {
                        HapticManager.shared.impact(style: .medium)
                    }
                } else {
                    // Time's up for current interval
                    if self.isPreparing {
                        // End of preparation - start first round
                        self.isPreparing = false
                        self.currentRound = 1
                        self.isWorking = true
                        self.timeRemaining = self.workTime
                        SoundManager.shared.playSound(for: .workStart)
                        
                        // Play final round audio if this is the only/last round
                        if self.currentRound == self.rounds {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                SoundManager.shared.playSound(for: .finalRound)
                            }
                        }
                        
                        HapticManager.shared.notification(type: .warning)
                    } else if self.isWorking {
                        // Check if this was the last round
                        if self.currentRound >= self.rounds {
                            // Workout complete - no final rest period
                            SoundManager.shared.playSound(for: .workoutComplete)
                            HapticManager.shared.notification(type: .success)
                            // Re-enable screen sleep when workout completes
                            UIApplication.shared.isIdleTimerDisabled = false
                            self.resetWorkout()
                        } else {
                            // Switch to rest
                            self.isWorking = false
                            self.timeRemaining = self.restTime
                            SoundManager.shared.playSound(for: .restStart)
                            HapticManager.shared.notification(type: .success)
                        }
                    } else {
                        // End of rest period - start next round
                        self.currentRound += 1
                        self.isWorking = true
                        self.timeRemaining = self.workTime
                        SoundManager.shared.playSound(for: .workStart)
                        
                        // Play final round audio if this is the last round
                        if self.currentRound == self.rounds {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                SoundManager.shared.playSound(for: .finalRound)
                            }
                        }
                        
                        HapticManager.shared.notification(type: .warning)
                    }
                }
            }
    }
} 