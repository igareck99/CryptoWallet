import SwiftUI

// MARK: - BubbleView

struct BubbleView<Content>: View where Content: View {

    // MARK: - Private Properties

    private let direction: BubbleShape.Direction
	private let shouldShowBackground: Bool
    private let content: () -> Content
    @State private var isAnimating = false

    // MARK: - Lifecycle

    init(
		direction: BubbleShape.Direction,
		shouldShowBackground: Bool = true,
		@ViewBuilder _ content: @escaping () -> Content
	) {
        self.direction = direction
		self.shouldShowBackground = shouldShowBackground
        self.content = content
    }

    // MARK: - Content

	var body: some View {
		HStack {
			if direction == .right { Spacer() }

			content()
				.background( backGroundColor())
				.clipShape( BubbleShape(direction: direction))
				.overlay( contentOverlay())

			if direction == .left { Spacer() }
		}
		.foregroundColor(.clear)
		.padding(direction == .left ? .leading : .trailing, 16)
		.padding(direction == .right ? .leading : .trailing, 22)
		.transition(isAnimating ? .opacity.animation(.easeIn) : .identity)
		.onAppear {
			if !isAnimating {
				isAnimating.toggle()
			}
		}
	}

	private func backGroundColor() -> Color {

		if !shouldShowBackground {
			return .clear
		}

		return direction == .right ? Color.aliceBlue : Color.royalOrange
	}

	@ViewBuilder
	private func contentOverlay() -> some View {

		if !shouldShowBackground {
			EmptyView()
				.opacity(0)
				.foregroundColor(.clear)
				.frame(width: 0, height: 0)
		} else {
			BubbleShape(direction: direction)
				.stroke(Color.pigeonPostApprox, lineWidth: 0.5)
				.foregroundColor(.aliceBlue)
		}
	}
}
