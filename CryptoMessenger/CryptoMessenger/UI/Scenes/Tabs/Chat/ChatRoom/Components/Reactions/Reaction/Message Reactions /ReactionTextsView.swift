import SwiftUI

struct ReactionTextsView: View {

	let model: ReactionTextsItem

	var body: some View {
		HStack(spacing: 6) {
			ForEach(model.texts) { textItem in
				Text(textItem.text)
					.font(textItem.font)
					.foregroundColor(textItem.color)
			}
		}
		.onTapGesture {
			model.onTapAction?()
		}
		.frame(height: 28)
		.frame(minWidth: 38)
		.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
		.background(model.backgroundColor)
		.cornerRadius(30)
	}
}

struct ReactionTextsView_Previews: PreviewProvider {
    static var previews: some View {
		ReactionTextsView(
			model: ReactionTextsItem(
				texts: textItems,
				backgroundColor: .dodgerBlueApprox
			)
		)
    }

	static let textItems = [
		ReactionTextItem(text: "😎"),
		ReactionTextItem(text: "2", color: .blackSqueezeApprox, font: .system(size: 11, weight: .medium))
	]
}
