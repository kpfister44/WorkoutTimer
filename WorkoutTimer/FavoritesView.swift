import SwiftUI

struct FavoritesView: View {
    @ObservedObject var workoutModel: WorkoutModel
    @State private var favorites = FavoriteWorkoutsManager.shared.getFavorites()
    @State private var showingAddFavorite = false
    @State private var newWorkoutName = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(favorites) { workout in
                Button(action: {
                    workoutModel.rounds = workout.rounds
                    workoutModel.workTime = workout.workTime
                    workoutModel.restTime = workout.restTime
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text("\(workout.rounds) rounds • \(workout.workTime)s work • \(workout.restTime)s rest")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteWorkout)
        }
        .navigationTitle("Favorite Workouts")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddFavorite = true
                }) {
                    Image(systemName: "plus")
                }
            }
            #else
            ToolbarItem {
                Button(action: {
                    showingAddFavorite = true
                }) {
                    Image(systemName: "plus")
                }
            }
            #endif
        }
        .alert("Save Current Workout", isPresented: $showingAddFavorite) {
            TextField("Workout Name", text: $newWorkoutName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if !newWorkoutName.isEmpty {
                    FavoriteWorkoutsManager.shared.saveWorkout(
                        name: newWorkoutName,
                        rounds: workoutModel.rounds,
                        workTime: workoutModel.workTime,
                        restTime: workoutModel.restTime
                    )
                    newWorkoutName = ""
                    favorites = FavoriteWorkoutsManager.shared.getFavorites()
                }
            }
        }
        .onAppear {
            favorites = FavoriteWorkoutsManager.shared.getFavorites()
        }
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            FavoriteWorkoutsManager.shared.deleteWorkout(withId: favorites[index].id)
        }
        favorites = FavoriteWorkoutsManager.shared.getFavorites()
    }
} 