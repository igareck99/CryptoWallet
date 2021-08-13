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

            let shape = ChatBubbleShape(direction: direction)

            content().background(
                shape
                    .fill(direction == .right ? Color(.lightBlue()) : Color(.beige()))
                    .overlay(
                        shape.stroke(Color(.gray()), lineWidth: 0.5)
                    )
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
        .scaleEffect(isAnimating ? 1 : 0.4)
        .animation(.easeInOut(duration: 0.4))
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }
}
