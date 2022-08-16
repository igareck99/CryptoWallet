import SwiftUI

struct PhotoView: View {

	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let url: URL?
	private let action: () -> Void

	init(
		isFromCurrentUser: Bool,
		shortDate: String,
		url: URL?,
		action: @escaping () -> Void
	) {
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.url = url
		self.action = action
	}

	var body: some View {
		ZStack {
			AsyncImage(
				url: url,
				placeholder: { ShimmerView().frame(width: 202, height: 245) },
				result: { Image(uiImage: $0).resizable() }
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
	}
}
