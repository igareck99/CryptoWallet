import SwiftUI

// MARK: - ContactView

struct ContactView: View {

    // MARK: - Intrernal properties

    private let shortDate: String
	private let name: String
	private let phone: String?
	private let url: URL?
	private let isFromCurrentUser: Bool
	private let reactionItems: [ReactionTextsItem]
	private let onButtonAction: () -> Void
	@State private var totalHeight: CGFloat = .zero

    // MARK: - Lifecycle

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

    // MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(spacing: 0) {
                AsyncImage(
					defaultUrl: url,
					placeholder: {
						ZStack {
							Color.dodgerTransBlue
							Text(name.firstLetter.uppercased())
								.foregroundColor(.white)
                                .font(.title2Bold22)
						}
					},
					result: { Image(uiImage: $0).resizable() }
				)
				.scaledToFill()
				.frame(width: 40, height: 40)
				.cornerRadius(20)

				VStack(alignment: .leading, spacing: 4) {
					Text(name)
                        .font(.bodyRegular17)
                        .foregroundColor(.chineseBlack)
					Text(phone ?? "-")
                        .font(.footnoteRegular13)
						.foregroundColor(.romanSilver)
				}
				.padding(.leading, 10)
				.padding(.top, 2)
			}

            Text(R.string.localizable.chatContactView)
				.frame(width: 220, height: 44)
                .font(.bodySemibold17)
				.foregroundColor(.dodgerBlue)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.dodgerBlue, lineWidth: 1)
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
				minHeight: totalHeight == 0 ? viewHeightNew(for: 212, reactionItems: reactionItems) : totalHeight
			)
			.padding(.top, 8)

			VStack(alignment: .trailing, spacing: 0) {
				CheckTextReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
			}
		}
		.frame(width: 244)
		.padding(.top, 8)
		.padding([.leading, .trailing], 12)
	}
}