import SwiftUI

struct ChatTextView: View {

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
		HStack(spacing: 2) {
			Text(text)
				.lineLimit(nil)
				.font(.regular(15))
				.foreground(.black())
				.padding(.leading, !isFromCurrentUser ? 22 : 16)
				.padding([.top, .bottom], 12)

			VStack(alignment: .center) {
				Spacer()
				HStack(spacing: 8) {
					Text(shortDate)
						.frame(width: 40, height: 10)
						.font(.light(12))
						.foreground(.black(0.5))
						.padding(.trailing, !isFromCurrentUser ? 16 : 0)

					if isFromCurrentUser {
						Image(imageName)
							.resizable()
							.frame(width: 13.5, height: 10, alignment: .center)
							.padding(.trailing, 16)
					}
				}
				.padding(.bottom, 8)
			}
		}
	}
}

/*
private func textRow(_ message: RoomMessage, text: String) -> some View {
	HStack(spacing: 2) {
		Text(text)
			.lineLimit(nil)
			.font(.regular(15))
			.foreground(.black())
			.padding(.leading, !isFromCurrentUser ? 22 : 16)
			.padding([.top, .bottom], 12)

		VStack(alignment: .center) {
			Spacer()
			HStack(spacing: 8) {
				Text(message.shortDate)
					.frame(width: 40, height: 10)
					.font(.light(12))
					.foreground(.black(0.5))
					.padding(.trailing, !isFromCurrentUser ? 16 : 0)

				if isFromCurrentUser {
					Image(R.image.chat.readCheck.name)
						.resizable()
						.frame(width: 13.5, height: 10, alignment: .center)
						.padding(.trailing, 16)
				}
			}
			.padding(.bottom, 8)
		}
	}
}
*/
