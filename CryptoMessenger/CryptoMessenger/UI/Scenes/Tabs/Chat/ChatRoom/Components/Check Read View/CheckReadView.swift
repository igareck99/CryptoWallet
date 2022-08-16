import SwiftUI

struct CheckReadView: View {

	private let time: String
	private let isFromCurrentUser: Bool

	init(time: String, isFromCurrentUser: Bool) {
		self.time = time
		self.isFromCurrentUser = isFromCurrentUser
	}

    var body: some View {
		ZStack {
			VStack {
				Spacer()
				HStack {
					if isFromCurrentUser {
						Spacer()
					}
					HStack(alignment: .center, spacing: 4) {
						Text(time)
							.font(.light(12))
							.foreground(.white())

						Image(R.image.chat.readCheckWhite.name)
					}
					.frame(width: 56, height: 16)
					.background(.black(0.4))
					.cornerRadius(8)

					if !isFromCurrentUser {
						Spacer()
					}
				}
				.padding(.bottom, 8)
				.padding(isFromCurrentUser ? .trailing : .leading, 10)
			}
		}
    }
}
