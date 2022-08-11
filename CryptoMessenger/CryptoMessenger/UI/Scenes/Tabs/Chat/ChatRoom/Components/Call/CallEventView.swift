import SwiftUI

struct CallEventView: View {

	private let isFromCurrentUser: Bool
	private let action: () -> Void
	private let eventTitle: String
	private let eventDateTime: String

	init(
		eventTitle: String,
		eventDateTime: String,
		isFromCurrentUser: Bool,
		action: @escaping () -> Void
	) {
		self.eventTitle = eventTitle
		self.eventDateTime = eventDateTime
		self.isFromCurrentUser = isFromCurrentUser
		self.action = action
	}

	var body: some View {
		BubbleView(direction: isFromCurrentUser ? .right : .left) {
			HStack {
				Image(systemName: "phone.fill")
					.frame(width: 48, height: 48, alignment: .center)
					.background(.blue)
					.foregroundColor(.white)
					.cornerRadius(24)
					.padding([.top, .bottom], 8)
				VStack(alignment: .leading) {
					Text(eventTitle)
						.font(.semibold(14))
						.foreground(.black())
						.padding(.trailing, 8)
						.padding(.bottom, 4)
					HStack(spacing: 8) {
						Text(eventDateTime)
							.font(.regular(12))
							.foreground(.darkGray())
					}
				}.padding([.bottom, .top], 8)
			}.padding([.trailing, .leading], 8)
		}.padding([.top, .bottom], 8)
			.onTapGesture(perform: action)
	}
}
