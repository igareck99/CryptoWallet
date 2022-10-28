import SwiftUI

struct ReactionTextItem: Identifiable {
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
}
