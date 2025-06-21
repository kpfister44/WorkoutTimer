import Foundation

class FavoriteWorkoutsManager {
    static let shared = FavoriteWorkoutsManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteWorkouts"
    
    private init() {}
    
    func saveWorkout(name: String, rounds: Int, workTime: Int, restTime: Int) {
        let workout = FavoriteWorkout(name: name, rounds: rounds, workTime: workTime, restTime: restTime)
        var favorites = getFavorites()
        favorites.append(workout)
        
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    func getFavorites() -> [FavoriteWorkout] {
        if let data = userDefaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([FavoriteWorkout].self, from: data) {
            return favorites
        }
        return []
    }
    
    func deleteWorkout(withId id: UUID) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == id }
        
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
} 