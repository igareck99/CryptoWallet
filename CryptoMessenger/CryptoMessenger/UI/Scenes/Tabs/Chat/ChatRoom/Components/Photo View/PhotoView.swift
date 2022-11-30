import SwiftUI

// MARK: - PhotoView

struct PhotoView: View {

    // MARK: - Private properties

	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let url: URL?
	private let action: () -> Void
	private let reactionItems: [ReactionTextsItem]
	@State private var totalHeight: CGFloat = .zero

    // MARK: - Lifecycle

	init(
		isFromCurrentUser: Bool,
		shortDate: String,
		url: URL?,
		reactionItems: [ReactionTextsItem],
		action: @escaping () -> Void
	) {
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.url = url
		self.reactionItems = reactionItems
		self.action = action
	}

    // MARK: - Body

	var body: some View {
		VStack(alignment: .trailing, spacing: 0) {
			ZStack(alignment: .bottom) {
				AsyncImage(
					url: url,
					placeholder: { ShimmerView().frame(width: 224, height: 245) },
					resultView: {
						Image(uiImage: $0).resizable().frame(width: 224, height: 245).cornerRadius(16)
					}
				)
				.scaledToFill()
				.frame(width: 224, height: 245)

				CheckReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
					.padding(.leading, isFromCurrentUser ? 0 : 130)
			}
			.frame(width: 224, height: 245)
			.onTapGesture {
				action()
			}

			VStack(alignment: .trailing, spacing: 0) {
				ReactionsGrid(
					totalHeight: $totalHeight,
                    viewModel: ReactionsGroupViewModel(items: reactionItems)
				)
				.frame(
                    minHeight: totalHeight == 0 ? viewHeightNew(for: 224, reactionItems: reactionItems) : totalHeight
				)
			}
			.frame(width: 224)
			.padding([.top, .bottom], 6)
            .padding(.trailing, isFromCurrentUser ? 8 : 0)
		}
		.frame(width: 224)
		.cornerRadius(16)
		.foregroundColor(.clear)
		.background(Color.clear)
	}
}
