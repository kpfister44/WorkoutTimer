import SwiftUI

/// View for displaying and managing favorite workouts.
struct FavoritesView: View {
    /// Reference to the workout model for updating workout settings.
    @ObservedObject var workoutModel: WorkoutModel
    /// List of favorite workouts loaded from persistent storage.
    @State private var favorites = FavoriteWorkoutsManager.shared.getFavorites()
    /// Controls the display of the add favorite workout alert.
    @State private var showingAddFavorite = false
    /// Text field for entering the name of a new favorite workout.
    @State private var newWorkoutName = ""
    /// Environment variable for dismissing this view.
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(favorites) { workout in
                Button(action: {
                    // Load the selected workout settings into the workout model.
                    workoutModel.rounds = workout.rounds
                    workoutModel.workTime = workout.workTime
                    workoutModel.restTime = workout.restTime
                    workoutModel.prepTime = workout.prepTime
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(workout.rounds) rounds • \(workout.prepTime)s prep • \(workout.workTime)s work • \(workout.restTime)s rest")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            }
            .onDelete(perform: handleDeleteWorkout)
            
            // Display helpful instructions based on whether favorites exist.
            if !favorites.isEmpty {
                Text("Swipe left on a workout to delete it")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                Text("Click the + button to save your commonly used workout timers")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("Favorite Workouts")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Favorite Workouts")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddFavorite = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
            #else
            ToolbarItem {
                Button(action: {
                    showingAddFavorite = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
            #endif
        }
        .alert("Save Current Workout", isPresented: $showingAddFavorite) {
            TextField("Workout Name", text: $newWorkoutName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if !newWorkoutName.isEmpty {
                    // Save the current workout settings as a favorite.
                    FavoriteWorkoutsManager.shared.saveWorkout(
                        name: newWorkoutName,
                        rounds: workoutModel.rounds,
                        workTime: workoutModel.workTime,
                        restTime: workoutModel.restTime,
                        prepTime: workoutModel.prepTime
                    )
                    newWorkoutName = ""
                    favorites = FavoriteWorkoutsManager.shared.getFavorites()
                }
            }
        }
        .onAppear {
            // Refresh the favorites list when the view appears.
            favorites = FavoriteWorkoutsManager.shared.getFavorites()
        }
    }
    
    /// Handles deletion of favorite workouts from the list.
    /// - Parameter offsets: The indices of workouts to delete.
    func handleDeleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            FavoriteWorkoutsManager.shared.deleteWorkout(withId: favorites[index].id)
        }
        favorites = FavoriteWorkoutsManager.shared.getFavorites()
    }
} 