import SwiftUI

// MARK: - ChatBubble

struct ChatBubble<Content>: View where Content: View {

    // MARK: - Private Properties

    private let direction: ChatBubbleShape.Direction
    private let content: () -> Content
    @State private var isAnimating = false

    // MARK: - Lifecycle

    init(direction: ChatBubbleShape.Direction, @ViewBuilder _ content: @escaping () -> Content) {
        self.direction = direction
        self.content = content
    }

    // MARK: - Content

    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }

            content()
                .background(
                    direction == .right ? Color(.lightBlue()) : Color(.beige())
                )
                .clipShape(
                    ChatBubbleShape(direction: direction)
                )
                .overlay(
                    ChatBubbleShape(direction: direction)
                        .stroke(Color(.lightGray()), lineWidth: 0.5)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )

            if direction == .left {
                Spacer()
            }
        }
        .padding(direction == .left ? .leading : .trailing, 16)
        .padding(direction == .right ? .leading : .trailing, 22)
        .padding([.top, .bottom], 2)
        .transition(isAnimating ? .move(edge: .top) : .identity)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1 : 0.8)
        .animation(.easeInOut(duration: 0.3))
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }
}
