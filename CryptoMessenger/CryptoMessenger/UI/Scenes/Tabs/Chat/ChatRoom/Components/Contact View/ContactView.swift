import SwiftUI

struct ContactView: View {

 private let shortDate: String
	private let name: String
	private let phone: String?
	private let url: URL?
	private let isFromCurrentUser: Bool
	private let reactionItem: [ReactionTextsItem]
	private let onButtonAction: () -> Void

	init(
		shortDate: String,
		name: String,
		phone: String?,
		url: URL?,
		isFromCurrentUser: Bool,
		reactionItem: [ReactionTextsItem],
		onButtonAction: @escaping () -> Void
	) {
		self.shortDate = shortDate
		self.name = name
		self.phone = phone
		self.url = url
		self.isFromCurrentUser = isFromCurrentUser
		self.reactionItem = reactionItem
		self.onButtonAction = onButtonAction
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(spacing: 0) {
				AsyncImage(
					url: url,
					placeholder: {
						ZStack {
							Color(.lightBlue())
							Text(name.firstLetter.uppercased())
								.foreground(.white())
								.font(.medium(22))
						}
					},
					result: { Image(uiImage: $0).resizable() }
				)
				.scaledToFill()
				.frame(width: 40, height: 40)
				.cornerRadius(20)

				VStack(alignment: .leading, spacing: 4) {
					Text(name)
						.font(.semibold(15))
						.foreground(.black())
					Text(phone ?? "-")
						.font(.regular(13))
						.foreground(.darkGray())
				}
				.padding(.leading, 10)
				.padding(.top, 2)
			}

			Button(action: {
				onButtonAction()
			},
				   label: {
				Text("Просмотр контакта")
					.frame(height: 44)
					.frame(minWidth: 215)
					.font(.bold(15))
					.foreground(.blue())
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color(.blue()), lineWidth: 1)
					)
			})
			.padding(.top, 12)

			VStack(alignment: .leading, spacing: 0) {
				ReactionsGroupView(
					viewModel: ReactionsGroupViewModel(
						items: reactionItem
					)
				)
			}
			.padding(.top, 8)
			VStack(alignment: .trailing, spacing: 0) {
				CheckTextReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
					.offset(x: 16, y: -8)
			}
		}
		.fixedSize(horizontal: true, vertical: true)
		.padding(.top, 8)
		.padding([.leading, .trailing], 12)
	}
}
