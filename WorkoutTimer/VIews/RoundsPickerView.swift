import SwiftUI

struct RoundsPickerView: View {
    @Binding var rounds: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("ROUNDS")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            HStack(spacing: 40) {
                Button(action: {
                    if rounds > 1 { rounds -= 1 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                Text("\(rounds)")
                    .font(.system(.largeTitle, design: .rounded)) 
                    .fontWeight(.bold)
                    .frame(minWidth: 80)
                Button(action: {
                    if rounds < 20 { rounds += 1 }
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