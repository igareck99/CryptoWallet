import SwiftUI

// MARK: - ReactionTextItem

struct ReactionTextItem: Identifiable, Equatable {
	let id = UUID()
	let text: String
	let color: Color
	let font: Font
    let width: CGFloat

    // MARK: - Lifecycle

    init(
        text: String,
        color: Color = .chineseBlack,
        font: Font = .system(size: 20),
        width: CGFloat = 38
    ) {
        self.text = text
		self.color = color
		self.font = font
        self.width = width
	}

	// MARK: - Equatable

	static func == (lhs: ReactionTextItem, rhs: ReactionTextItem) -> Bool {
		lhs.id == rhs.id && lhs.text == rhs.text
	}
}
