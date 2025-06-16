import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(for event: SoundEvent) {
        guard let soundURL = Bundle.main.url(forResource: event.rawValue, withExtension: "mp3", subdirectory: "Sounds") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
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