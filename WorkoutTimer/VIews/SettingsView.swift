import SwiftUI

/// View for managing app settings and preferences.
struct SettingsView: View {
    /// App storage for dark mode preference that persists across app launches.
    @AppStorage("isDarkMode") private var isDarkMode = false
    /// Controls the display of the privacy policy sheet.
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            Form {
                // Appearance settings section.
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                }
                
                // About section with privacy policy link.
                Section(header: Text("About")) {
                    Button(action: {
                        showingPrivacyPolicy = true
                    }) {
                        HStack {
                            Image(systemName: "hand.raised")
                                .foregroundColor(.blue)
                            Text("Privacy Policy")
                        }
                    }
                }
                
                // App information section.
                Section(header: Text("App Info")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        // Display app version from bundle info.
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    SettingsView()
} 