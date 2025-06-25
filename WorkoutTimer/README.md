# WorkoutTimer

A clean, intuitive iOS app for interval training workouts with customizable work and rest periods.

![iOS 15.6+](https://img.shields.io/badge/iOS-15.6+-blue.svg)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Yes-green.svg)

## Features

### 🏃‍♂️ **Interval Training**
- Customizable work and rest intervals (1-59 minutes each)
- Configurable number of rounds (1-20)
- Visual progress indicator with circular timer
- Automatic transitions between work and rest periods

### 🎵 **Audio Integration**
- Sound notifications for interval changes
- **Plays alongside your music** - won't interrupt your playlist
- Haptic feedback for last 3 seconds of each interval

### ⭐ **Favorite Workouts**
- Save your commonly used workout configurations
- Quick access to your preferred routines
- Easy management with swipe-to-delete

### 🎨 **User Experience**
- Clean, modern SwiftUI interface
- Dark mode support
- Intuitive controls (play, pause, resume, reset)
- Real-time workout status display

### �� **Privacy First**
- No data collection or external transmission
- All data stored locally on your device
- No third-party analytics or tracking

## Screenshots

*[Add screenshots of your app here - you can take them from the simulator or device]*

## Requirements

- iOS 15.6+
- Xcode 15.0+
- Swift 5.0+

## Installation

### For Users
Not yet available on the app store. Need to contact Kyle Pfister for TestFlight copy.

### For Developers
1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/WorkoutTimer.git
   ```
2. Open `WorkoutTimer.xcodeproj` in Xcode
3. Build and run on your device or simulator

## Usage

1. **Set up your workout:**
   - Choose number of rounds (1-20)
   - Set work time (1-59 minutes)
   - Set rest time (1-59 minutes)

2. **Start your workout:**
   - Tap "START" to begin
   - The app will automatically cycle through work and rest periods
   - Use pause/resume as needed

3. **Save favorites:**
   - Configure your preferred workout settings
   - Tap the hamburger menu (☰) to access favorites
   - Save your current configuration for quick access

## Architecture

The app follows MVVM architecture with SwiftUI:

- **Models**: `WorkoutModel` manages workout state and timer logic
- **Views**: SwiftUI views for UI components
- **Managers**: Singleton classes for sound, haptics, and favorites
- **Data**: Local storage using UserDefaults

### Key Components

- `WorkoutModel`: Core timer and workout state management
- `SoundManager`: Audio playback with music-friendly settings
- `HapticManager`: Tactile feedback for better user experience
- `FavoriteWorkoutsManager`: Local storage for saved workouts

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you have any questions or need support, please:
- Open an issue on GitHub

---

**Built with ❤️ using SwiftUI**