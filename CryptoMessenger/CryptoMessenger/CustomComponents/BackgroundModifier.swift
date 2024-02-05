import SwiftUI

// MARK: - BackgroundImage

struct BackgroundImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(R.image.chat.chatBackground.image
            .resizable()
            .scaledToFill())
    }
}
