import SwiftUI

struct ReactionTextsItem: Identifiable, ViewGeneratable {

	let id = UUID()
	let texts: [ReactionTextItem]
	let backgroundColor: Color

	init(
		texts: [ReactionTextItem],
		backgroundColor: Color
	) {
		self.texts = texts
		self.backgroundColor = backgroundColor
	}

	// MARK: - ViewGeneratable

	@ViewBuilder
	func view() -> some View {
		ReactionTextsView(model: self)
	}
}
