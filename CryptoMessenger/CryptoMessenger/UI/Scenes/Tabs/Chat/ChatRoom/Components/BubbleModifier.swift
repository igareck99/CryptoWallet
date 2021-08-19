import SwiftUI

// MARK: - BubbleModifier

struct BubbleModifier: ViewModifier {

    // MARK: - Internal Properties

    let isCurrentUser: Bool

    // MARK: - Internal Methods

    func body(content: Content) -> some View {
        content
            .padding([.top, .bottom], 12)
            .padding(.leading, isCurrentUser ? 22 : 16)
            .padding(.trailing, isCurrentUser ? 16 : 22)
            .lineLimit(nil)
            .font(.regular(15))
            .background(.clear)
            .foreground(isCurrentUser ? .black() : .black())
    }
}
