import SwiftUI

struct ReactionTextsItem: Identifiable, ViewGeneratable {

	let id = UUID()
	let texts: [ReactionTextItem]
	let backgroundColor: Color
	let onTapAction: VoidBlock?

	init(
		texts: [ReactionTextItem],
		backgroundColor: Color,
		onTapAction: VoidBlock? = nil
	) {
		self.texts = texts
		self.backgroundColor = backgroundColor
		self.onTapAction = onTapAction
	}

	// MARK: - ViewGeneratable

	@ViewBuilder
	func view() -> some View {
		ReactionTextsView(model: self)
	}

	// MARK: - Equatable

	static func == (lhs: ReactionTextsItem, rhs: ReactionTextsItem) -> Bool {
		lhs.id == rhs.id && lhs.texts == rhs.texts
	}
}
