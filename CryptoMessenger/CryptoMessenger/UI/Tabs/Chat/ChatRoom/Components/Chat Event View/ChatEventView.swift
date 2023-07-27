import SwiftUI

// MARK: - ChatEventView

struct ChatEventView: View {

    // MARK: - Private Properties

	private let text: String
	private let font: Font
	private let backgroundColor: Color
	private let foregroundColor: Color?

    // MARK: - Lifecycle

	init(
		text: String,
        font: Font = .system(size: 14, weight: .regular),
		backgroundColor: Color = Color(red: 242 / 255, green: 160 / 255, blue: 76 / 255),
		foregroundColor: Color? = nil
	) {
		self.text = text
		self.font = font
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
	}

    // MARK: - Body

    var body: some View {
		HStack {
			Text(text)
				.font(font)
				.padding(.horizontal, 17)
				.padding(.vertical, 3)
				.foregroundColor(foregroundColor)
				.multilineTextAlignment(.center)
		}
		.background(backgroundColor)
		.cornerRadius(8)
		.padding(.vertical, 8)
    }
}

// MARK: - ChatEventView

extension ChatEventView {

    // MARK: - Internal Methods

	func configureInnerOuterShadow() -> some View {
		self
            .shadow(color: Color.romanSilver, radius: 0, x: 0, y: -0.4)
            .shadow(color: Color.chineseShadow, radius: 0, x: 0, y: 0.4)
	}

	func configureOuterShadow() -> some View {
        self.shadow(color: Color.chineseShadow, radius: 0, x: 0, y: 0.4)
	}
}
