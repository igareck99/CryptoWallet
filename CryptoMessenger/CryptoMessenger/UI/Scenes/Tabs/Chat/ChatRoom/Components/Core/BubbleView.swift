import SwiftUI

// MARK: - BubbleView

struct BubbleView<Content>: View where Content: View {

    // MARK: - Private Properties

    private let direction: BubbleShape.Direction
    private let content: () -> Content
    @State private var isAnimating = false

    // MARK: - Lifecycle

    init(direction: BubbleShape.Direction, @ViewBuilder _ content: @escaping () -> Content) {
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
                    BubbleShape(direction: direction)
                )
                .overlay(
                    BubbleShape(direction: direction)
                        .stroke(Color(.custom(#colorLiteral(red: 0.7921568627, green: 0.8117647059, blue: 0.8235294118, alpha: 1))), lineWidth: 0.5)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )

            if direction == .left {
                Spacer()
            }
        }
        .padding(direction == .left ? .leading : .trailing, 16)
        .padding(direction == .right ? .leading : .trailing, 22)
        .transition(isAnimating ? .move(edge: .bottom).animation(.easeIn) : .identity)
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }
}
