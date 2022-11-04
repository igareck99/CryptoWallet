import SwiftUI

struct ReactionTextItem: Identifiable, Equatable {
	let id = UUID()
	let text: String
	let color: Color
	let font: Font

	init(
		text: String,
		color: Color = .zeroColor,
		font: Font = .system(size: 20)
	) {
		self.text = text
		self.color = color
		self.font = font
	}

	// MARK: - Equatable

	static func == (lhs: ReactionTextItem, rhs: ReactionTextItem) -> Bool {
		lhs.id == rhs.id && lhs.text == rhs.text
	}
}
