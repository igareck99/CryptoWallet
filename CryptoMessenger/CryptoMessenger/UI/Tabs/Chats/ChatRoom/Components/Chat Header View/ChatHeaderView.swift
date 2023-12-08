import SwiftUI

struct ChatHeaderView: View {

	private let isOnline: Bool
	private let chatOnline: String
	private let chatOffline: String
	private let displayname: String?
	private let backButton: Image
	private let roomAvatar: URL?
	private let phoneButton: Image
	private let settingsButton: Image
	private let messageStatus: MessageStatus

	init(
		displayname: String?,
		backButton: Image,
		roomAvatar: URL?,
		isOnline: Bool,
		chatOnline: String,
		chatOffline: String,
		phoneButton: Image,
		settingsButton: Image,
		messageStatus: MessageStatus
	) {
		self.displayname = displayname
		self.backButton = backButton
		self.roomAvatar = roomAvatar
		self.isOnline = isOnline
		self.chatOnline = chatOnline
		self.chatOffline = chatOffline
		self.phoneButton = phoneButton
		self.settingsButton = settingsButton
		self.messageStatus = messageStatus
	}

	var body: some View {

		VStack {
			Spacer()
			HStack(spacing: 0) {
				Spacer().frame(width: 16)
				Button(action: {
//					presentationMode.wrappedValue.dismiss()
				}, label: { backButton })

				Spacer().frame(width: 16)

                AsyncImage(
					defaultUrl: roomAvatar,
					placeholder: {
						ZStack {
							Color.aliceBlue
							Text(displayname?.firstLetter.uppercased() ?? "?")
								.foregroundColor(.white)
                                .font(.title3Regular20)
						}
					},
					result: {
						Image(uiImage: $0).resizable()
					}
				)
				.scaledToFill()
				.frame(width: 36, height: 36)
				.cornerRadius(18)

				Spacer().frame(width: 12)

				VStack(alignment: .leading) {
					Text(displayname ?? "")
						.lineLimit(1)
                        .font(.bodySemibold17)
						.foregroundColor(.chineseBlack)
					Text(isOnline ? chatOnline : chatOffline)
					.lineLimit(1)
                    .font(.footnoteRegular13)
					.foregroundColor(messageStatus == .online ? .dodgerBlue : .chineseBlack04)
				}

				Spacer()
				Button(action: {

				}, label: {
					phoneButton.resizable().frame(width: 24, height: 24, alignment: .center)
				})
				.padding(.trailing, 12)

				Button(action: {

				}, label: {
					settingsButton.resizable().frame(width: 24, height: 24, alignment: .center)
				})

				Spacer().frame(width: 16)
			}
			.padding(.bottom, 16)
		}
		.frame(height: 106)
		.background(.white)
	}
}
