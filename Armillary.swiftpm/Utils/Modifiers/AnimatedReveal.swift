import SwiftUI

struct FadeSlideModifier: ViewModifier {
    let isActive: Bool
    let duration: Double

    func body(content: Content) -> some View {
        content
            .offset(y: isActive ? 0 : -10)
            .opacity(isActive ? 1 : 0)
            .animation(.easeOut(duration: duration), value: isActive)
    }
}

// easy
extension View {
    func fadeSlideIn(isActive: Bool = true, duration: Double = 0.5) -> some View {
        modifier(FadeSlideModifier(isActive: isActive, duration: duration))
    }
}
