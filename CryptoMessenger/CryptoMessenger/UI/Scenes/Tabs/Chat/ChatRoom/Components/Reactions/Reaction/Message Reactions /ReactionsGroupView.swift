import SwiftUI

struct ReactionsGroupView<ViewModel: ReactionsGroupViewModelProtocol>: View {

	@ObservedObject var viewModel: ViewModel

	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			ForEach(viewModel.items, id: \.id ) { item in
				item.view()
			}
		}
	}
}

struct ReactionsGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ReactionsGroupView(viewModel: ReactionsGroupViewModel(items: textsMock))
	}

	static let textsMock = [
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
				ReactionTextItem(text: "💩"),
				ReactionTextItem(text: "42", color: .blackSqueezeApprox, font: .system(size: 11, weight: .medium))
			],
			backgroundColor: .dodgerBlueApprox
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
