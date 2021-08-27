import SwiftUI

// MARK: - BubbleModifier

struct BubbleModifier: ViewModifier {

    // MARK: - Internal Properties

    let isCurrentUser: Bool

    // MARK: - Internal Methods

    func body(content: Content) -> some View {
        content
            .lineLimit(nil)
            .font(.regular(15))
            .background(.clear)
            .foreground(isCurrentUser ? .black() : .black())
    }
}
