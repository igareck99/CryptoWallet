import SwiftUI

extension ChatTextsView {

	private static let longText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
"""

	func reactionsGroupView() -> some View {
		ReactionsGroupView(viewModel: ReactionsGroupViewModel(items: emptyTextsMock))
	}

	var emptyTextsMock: [ReactionTextsItem] { [ReactionTextsItem]() }

	var textsMock1: [ReactionTextsItem] {
		[
			ReactionTextsItem(
				texts: [
					ReactionTextItem(text: "😎"),
					ReactionTextItem(text: "2", color: .blackSqueezeApprox, font: .system(size: 11, weight: .medium))
				],
				backgroundColor: .dodgerBlueApprox
			),
			ReactionTextsItem(
				texts: [
					ReactionTextItem(text: "😚"),
					ReactionTextItem(text: "2", color: .dodgerBlueApprox, font: .system(size: 11, weight: .medium))
				],
				backgroundColor: .onahauApprox
			),
			ReactionTextsItem(
				texts: [
					ReactionTextItem(text: "😻")
				],
				backgroundColor: .dodgerBlueApprox
			),
			ReactionTextsItem(
				texts: [
					ReactionTextItem(text: "👍"),
					ReactionTextItem(text: "12", color: .dodgerBlueApprox, font: .system(size: 11, weight: .medium))
				],
				backgroundColor: .onahauApprox
			),
			ReactionTextsItem(
				texts: [
					ReactionTextItem(text: "+2", color: .dodgerBlueApprox, font: .system(size: 11, weight: .medium))
				],
				backgroundColor: .onahauApprox
			)
		]
	}
}
