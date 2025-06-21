import Foundation

struct FavoriteWorkout: Codable, Identifiable {
    var id = UUID()
    var name: String
    var rounds: Int
    var workTime: Int
    var restTime: Int
} 