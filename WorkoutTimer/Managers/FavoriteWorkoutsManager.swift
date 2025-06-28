import Foundation

/// Singleton class responsible for managing favorite workouts using UserDefaults.
class FavoriteWorkoutsManager {
    /// Shared instance for global access.
    static let shared = FavoriteWorkoutsManager()
    
    /// Reference to UserDefaults for persistent storage.
    private let userDefaults = UserDefaults.standard
    /// Key used to store favorite workouts in UserDefaults.
    private let favoritesKey = "favoriteWorkouts"
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Saves a new workout to the list of favorites.
    /// - Parameters:
    ///   - name: Name of the workout.
    ///   - rounds: Number of rounds.
    ///   - workTime: Work time in seconds.
    ///   - restTime: Rest time in seconds.
    ///   - prepTime: Preparation time in seconds.
    func saveWorkout(name: String, rounds: Int, workTime: Int, restTime: Int, prepTime: Int = 10) {
        let workout = FavoriteWorkout(name: name, rounds: rounds, workTime: workTime, restTime: restTime, prepTime: prepTime)
        var favorites = getFavorites()
        favorites.append(workout)
        
        // Encode and save the updated favorites array to UserDefaults.
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    /// Retrieves the list of favorite workouts from UserDefaults.
    /// - Returns: An array of FavoriteWorkout objects.
    func getFavorites() -> [FavoriteWorkout] {
        if let data = userDefaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([FavoriteWorkout].self, from: data) {
            return favorites
        }
        return []
    }
    
    /// Deletes a workout from favorites by its unique identifier.
    /// - Parameter id: The UUID of the workout to delete.
    func deleteWorkout(withId id: UUID) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == id }
        
        // Encode and save the updated favorites array to UserDefaults.
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
} 