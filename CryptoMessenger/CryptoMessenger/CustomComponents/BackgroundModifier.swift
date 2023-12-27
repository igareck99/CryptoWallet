import SwiftUI

// MARK: - BackgroundImage

struct BackgroundImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.8)
            .background(R.image.chat.chatBackground.image
            .resizable()
            .scaledToFill())
    }
}
