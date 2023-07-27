import SwiftUI

// MARK: - FlippedModifier

struct FlippedModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func flippedUpsideDown() -> some View { modifier(FlippedModifier()) }
}
