import SwiftUI

struct ChatTextsView: View {

	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let text: String
	private let imageName: String

	init(
		isFromCurrentUser: Bool,
		shortDate: String,
		text: String,
		imageName: String = R.image.chat.readCheck.name
	) {
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.text = text
		self.imageName = imageName
	}

	var body: some View {
		HStack(spacing: 0) {
			VStack(alignment: .leading, spacing: 0) {
				Text(text)
					.lineLimit(nil)
					.font(.regular(15))
					.foreground(.black())
					.padding(.top, 8)
					.fixedSize(horizontal: false, vertical: true)

				reactionsGroupView()
					.padding(.top, 4)
					.padding(.bottom, 2)

				HStack(spacing: 0) {
					Color.clear.frame(height: 0)
					Text(shortDate)
						.frame(width: 40, height: 10)
						.font(.light(12))
						.foreground(.black(0.5))
						.fixedSize()

					if isFromCurrentUser {
						Image(imageName)
							.resizable()
							.frame(width: 13.5, height: 10, alignment: .center)
					}
				}
				.padding(.bottom, 8)
			}
			.padding(.leading, isFromCurrentUser ? 8 : 16)
			.padding(.trailing, isFromCurrentUser ? 16 : 8)
		}
		.scaledToFit()
	}
}

