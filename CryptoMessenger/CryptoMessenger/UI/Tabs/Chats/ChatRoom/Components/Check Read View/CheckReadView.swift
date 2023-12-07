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
                    Spacer()
                    HStack(alignment: .center, spacing: 4) {
                        Text(time)
                            .font(.caption1Regular12)
                            .foregroundColor(.white)
                        Image(R.image.chat.readCheckWhite.name)
                    }
                    .frame(width: 56, height: 16)
                    .background(Color.chineseBlack04)
                    .cornerRadius(8)
				}
				.padding(.bottom, 8)
				.padding(.trailing, 10)
			}
		}
    }
}
