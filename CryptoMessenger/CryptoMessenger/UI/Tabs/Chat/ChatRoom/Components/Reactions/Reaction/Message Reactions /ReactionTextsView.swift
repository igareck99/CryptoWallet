import SwiftUI

// MARK: - ReactionTextsView

struct ReactionTextsView: View {

    // MARK: - Private Properties

	let model: ReactionTextsItem

    // MARK: - Body

	var body: some View {
        HStack(spacing: 6) {
            ForEach(model.texts) { textItem in
                Text(textItem.text)
                    .font(textItem.font)
                    .foregroundColor(textItem.color)
            }
        }
		.contentShape(Rectangle())
		.onTapGesture {
			model.onTapAction?()
		}
		.frame(height: 28)
        .frame(width: model.texts[0].width)
		.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
		.background(model.backgroundColor)
		.cornerRadius(30)
	}
}
