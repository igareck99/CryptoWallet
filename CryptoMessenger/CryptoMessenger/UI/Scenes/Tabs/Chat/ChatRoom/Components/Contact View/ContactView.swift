import SwiftUI

struct ContactView: View {

 private let shortDate: String
	private let name: String
	private let phone: String?
	private let url: URL?
	private let isFromCurrentUser: Bool
	private let reactionItems: [ReactionTextsItem]
	private let onButtonAction: () -> Void
	@State private var totalHeight: CGFloat = .zero

	init(
		shortDate: String,
		name: String,
		phone: String?,
		url: URL?,
		isFromCurrentUser: Bool,
		reactionItems: [ReactionTextsItem],
		onButtonAction: @escaping () -> Void
	) {
		self.shortDate = shortDate
		self.name = name
		self.phone = phone
		self.url = url
		self.isFromCurrentUser = isFromCurrentUser
		self.reactionItems = reactionItems
		self.onButtonAction = onButtonAction
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(spacing: 0) {
				AsyncImage(
					url: url,
					placeholder: {
						ZStack {
							Color.azureRadianceApprox
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

			Text("Просмотр контакта")
				.frame(width: 220, height: 44)
				.font(.bold(15))
				.foreground(.blue())
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(Color(.blue()), lineWidth: 1)
						.padding([.leading, .trailing], -8)
				)
				.padding(.top, 12)
				.padding([.leading, .trailing], 8)
				.onTapGesture {
					onButtonAction()
				}

			ReactionsGrid(
				totalHeight: $totalHeight,
				viewModel: ReactionsGroupViewModel(items: reactionItems)
			)
			.frame(
				minHeight: totalHeight == 0 ? precalculateViewHeight(for: 244, itemsCount: reactionItems.count) : totalHeight
			)
			.padding(.top, 8)

			VStack(alignment: .trailing, spacing: 0) {
				CheckTextReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
					.offset(x: 16, y: -8)
			}
		}
		.frame(width: 244)
		.padding(.top, 8)
		.padding([.leading, .trailing], 12)
	}
}
