import SwiftUI

struct PhotoView: View {

	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let url: URL?
	private let action: () -> Void
	private let reactionItem: [ReactionTextsItem]

	init(
		isFromCurrentUser: Bool,
		shortDate: String,
		url: URL?,
		reactionItem: [ReactionTextsItem],
		action: @escaping () -> Void
	) {
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.url = url
		self.reactionItem = reactionItem
		self.action = action
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ZStack(alignment: .bottom) {
				AsyncImage(
					url: url,
					placeholder: { ShimmerView().frame(width: 202, height: 245) },
					resultView: {
						Image(uiImage: $0).resizable().frame(width: 202, height: 245)
					}
				)
				.scaledToFill()
				.frame(width: 202, height: 245)

				CheckReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
					.padding(.leading, isFromCurrentUser ? 0 : 130)
			}
			.frame(width: 202, height: 245)
			.onTapGesture {
				action()
			}
			ReactionsGroupView(
				viewModel: ReactionsGroupViewModel(items: reactionItem)
			)
			.padding(.top, 6)
		}
		.foregroundColor(.clear)
	}
}
