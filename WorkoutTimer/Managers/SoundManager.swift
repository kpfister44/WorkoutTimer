import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
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
    
    private func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    enum SoundEvent: String {
        case workStart = "work_start"
        case restStart = "rest_start"
        case workoutComplete = "workout_complete"
    }
} 