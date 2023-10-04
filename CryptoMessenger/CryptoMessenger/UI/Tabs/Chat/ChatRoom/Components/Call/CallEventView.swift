import SwiftUI

// MARK: - CallEventView

struct CallEventView: View {

    // MARK: - Private Properties

	private let isFromCurrentUser: Bool
	private let action: () -> Void
	private let eventTitle: String
	private let eventDateTime: String
    
    // MARK: - Lifecycle

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

    // MARK: - Body

	var body: some View {
		BubbleView(direction: isFromCurrentUser ? .right : .left) {
			HStack {
				Image(systemName: "phone.fill")
					.frame(width: 48, height: 48, alignment: .center)
					.background(Color.dodgerBlue)
					.foregroundColor(.white)
					.cornerRadius(24)
					.padding([.top, .bottom], 8)
				VStack(alignment: .leading) {
					Text(eventTitle)
                        .font(.subheadline2Regular14)
						.foregroundColor(.chineseBlack)
						.padding(.trailing, 8)
						.padding(.bottom, 4)
					HStack(spacing: 8) {
						Text(eventDateTime)
                            .font(.caption1Regular12)
							.foregroundColor(.romanSilver)
					}
				}.padding([.bottom, .top], 8)
			}.padding(.trailing, 8)
                .padding(.leading, !isFromCurrentUser ? 16 : 8)
		}.padding([.top, .bottom], 8)
			.onTapGesture(perform: action)
	}
}
