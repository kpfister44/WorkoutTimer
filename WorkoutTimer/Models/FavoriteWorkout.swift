import Foundation

struct FavoriteWorkout: Codable, Identifiable {
    var id = UUID()
    var name: String
    var rounds: Int
    var workTime: Int
    var restTime: Int
    var prepTime: Int
    
    init(id: UUID = UUID(), name: String, rounds: Int, workTime: Int, restTime: Int, prepTime: Int = 10) {
        self.id = id
        self.name = name
        self.rounds = rounds
        self.workTime = workTime
        self.restTime = restTime
        self.prepTime = prepTime
    }
} 