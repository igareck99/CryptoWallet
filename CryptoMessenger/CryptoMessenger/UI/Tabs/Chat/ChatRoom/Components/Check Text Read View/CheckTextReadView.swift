import SwiftUI

struct CheckTextReadView: View {

	private let time: String
	private let isFromCurrentUser: Bool
	private let imageName: String

	init(
		time: String,
		isFromCurrentUser: Bool,
		imageName: String = R.image.chat.readCheck.name
	) {
		self.time = time
		self.isFromCurrentUser = isFromCurrentUser
		self.imageName = imageName
	}

    var body: some View {
		ZStack {
			VStack {
				Spacer()
				HStack {
					if isFromCurrentUser {
						Spacer()
					}
					HStack(spacing: 6) {
						Text(time)
							.frame(width: 40, height: 10)
                            .font(.system(size: 12, weight: .light))
							.foregroundColor(.chineseBlack04)
							.padding(.trailing, !isFromCurrentUser ? 16 : 0)
							.padding(.leading, isFromCurrentUser ? 0 : 16)

						if isFromCurrentUser {
							Image(imageName)
								.resizable()
								.frame(width: 13.5, height: 10, alignment: .center)
								.padding(.trailing, 16)
						}
					}
					if !isFromCurrentUser {
						Spacer()
					}
				}
				.padding(.bottom, 8)
			}
		}
    }
}
