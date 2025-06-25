import SwiftUI

/// View displaying the app's privacy policy information.
struct PrivacyPolicyView: View {
    /// Environment variable for dismissing this view.
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        // Last updated date for the privacy policy.
                        Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Data Collection section.
                        Text("Data Collection")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("WorkoutTimer does not collect, store, or transmit any personal information. All data, including your favorite workout configurations, is stored locally on your device using iOS UserDefaults.")
                        
                        // Local Storage section.
                        Text("Local Storage")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("The app stores the following information locally on your device:")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Your favorite workout configurations (name, rounds, work time, rest time)")
                            Text("• This data is stored using iOS UserDefaults and is not accessible to us or any third parties")
                        }
                        .padding(.leading)
                        
                        // No External Data Transmission section.
                        Text("No External Data Transmission")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("WorkoutTimer does not connect to any external servers or transmit any data over the internet. All functionality operates entirely on your device.")
                        
                        // Third-Party Services section.
                        Text("Third-Party Services")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("This app does not use any third-party analytics, advertising, or tracking services.")
                        
                        // Children's Privacy section.
                        Text("Children's Privacy")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("WorkoutTimer does not knowingly collect any personal information from children under 13. The app is designed to be safe for users of all ages.")
                        
                        // Changes to Policy section.
                        Text("Changes to This Policy")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("If we make any changes to this privacy policy, we will update this document and the app version.")
                        
                        // Contact section.
                        Text("Contact")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("If you have any questions about this privacy policy, please contact us through the App Store review system.")
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PrivacyPolicyView()
} 