import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    enum NotificationType {
        case success, warning, error
    }
    
    enum ImpactStyle {
        case light, medium, heavy, soft, rigid
    }
    
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