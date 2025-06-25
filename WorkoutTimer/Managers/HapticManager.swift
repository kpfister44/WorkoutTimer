import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Singleton class responsible for managing haptic feedback in the app.
class HapticManager {
    /// Shared instance for global access.
    static let shared = HapticManager()
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Types of notification haptic feedback.
    enum NotificationType {
        case success, warning, error
    }
    
    /// Types of impact haptic feedback.
    enum ImpactStyle {
        case light, medium, heavy, soft, rigid
    }
    
    /// Triggers a notification haptic feedback of the specified type.
    /// - Parameter type: The type of notification feedback (success, warning, error).
    func notification(type: NotificationType) {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .warning:
            generator.notificationOccurred(.warning)
        case .error:
            generator.notificationOccurred(.error)
        }
        #endif
    }
    
    /// Triggers an impact haptic feedback of the specified style.
    /// - Parameter style: The style of impact feedback (light, medium, heavy, soft, rigid).
    func impact(style: ImpactStyle) {
        #if os(iOS)
        let uiStyle: UIImpactFeedbackGenerator.FeedbackStyle
        
        switch style {
        case .light:
            uiStyle = .light
        case .medium:
            uiStyle = .medium
        case .heavy:
            uiStyle = .heavy
        case .soft:
            uiStyle = .soft
        case .rigid:
            uiStyle = .rigid
        }
        
        let generator = UIImpactFeedbackGenerator(style: uiStyle)
        generator.impactOccurred()
        #endif
    }
}