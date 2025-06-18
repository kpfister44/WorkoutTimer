import SwiftUI

struct RoundsPickerView: View {
    @Binding var rounds: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("ROUNDS")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.red)
            HStack(spacing: 40) {
                Button(action: {
                    if rounds > 1 { rounds -= 1 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                }
                Text("\(rounds)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .frame(minWidth: 80)
                Button(action: {
                    if rounds < 20 { rounds += 1 }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(24)
        .shadow(radius: 2)
    }
} 