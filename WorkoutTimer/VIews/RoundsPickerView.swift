import SwiftUI

/// View for selecting the number of workout rounds with increment/decrement buttons.
struct RoundsPickerView: View {
    /// Binding to the rounds value that can be modified by parent views.
    @Binding var rounds: Int

    var body: some View {
        VStack(spacing: 8) {
            // Title label for the rounds picker.
            Text("ROUNDS")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            
            HStack(spacing: 40) {
                // Decrement button - decreases rounds (minimum 1).
                Button(action: {
                    if rounds > 1 { rounds -= 1 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                
                // Current rounds display with rounded font design.
                Text("\(rounds)")
                    .font(.system(.largeTitle, design: .rounded)) 
                    .fontWeight(.bold)
                    .frame(minWidth: 80)
                
                // Increment button - increases rounds (maximum 60).
                Button(action: {
                    if rounds < 60 { rounds += 1 }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(24)
        .shadow(radius: 2)
    }
} 