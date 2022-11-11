import SwiftUI

// MARK: - ReactionTextsItem

struct ReactionTextsItem: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

	let id = UUID()
	let texts: [ReactionTextItem]
	let backgroundColor: Color
	let onTapAction: VoidBlock?

    // MARK: - Lifecycle

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

    func getItemWidth() -> CGFloat {
        return texts.first?.width ?? 0
    }

	// MARK: - Equatable

	static func == (lhs: ReactionTextsItem, rhs: ReactionTextsItem) -> Bool {
		lhs.id == rhs.id && lhs.texts == rhs.texts
	}
}
