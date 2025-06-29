import Foundation
import AVFoundation

/// Singleton class responsible for managing and playing sound effects in the app.
class SoundManager {
    /// Shared instance for global access.
    static let shared = SoundManager()
    
    /// The audio player instance used for playing sounds.
    private var audioPlayer: AVAudioPlayer?
    
    /// Private initializer to enforce singleton pattern and configure audio session.
    private init() {
        do {
            // Set audio session to allow mixing with other audio (e.g., music from other apps)
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    /// Plays a sound corresponding to the given event.
    /// - Parameter event: The type of sound event to play.
    func playSound(for event: SoundEvent) {
        // Try with subdirectory first (folder reference)
        if let soundURL = Bundle.main.url(forResource: event.rawValue, withExtension: "mp3", subdirectory: "Sounds") {
            playAudio(from: soundURL)
            return
        }
        
        // Try without subdirectory (group)
        if let soundURL = Bundle.main.url(forResource: event.rawValue, withExtension: "mp3") {
            playAudio(from: soundURL)
            return
        }
    }
    
    /// Helper method to play audio from a given file URL.
    /// - Parameter url: The URL of the audio file to play.
    private func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    /// Enum representing the different sound events in the app.
    enum SoundEvent: String {
        case prepStart = "prep_start"
        case workStart = "work_start"
        case restStart = "rest_start"
        case workoutComplete = "workout_complete"
        case finalRound = "final_round"
        case lastThreeSeconds = "last_three_seconds"
    }
} 