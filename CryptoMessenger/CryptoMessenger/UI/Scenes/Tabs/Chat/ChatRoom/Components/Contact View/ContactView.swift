import SwiftUI

struct ContactView: View {

 private let shortDate: String
	private let name: String
	private let phone: String?
	private let url: URL?
	private let isFromCurrentUser: Bool
	private let onButtonAction: () -> Void

	init(
		shortDate: String,
		name: String,
		phone: String?,
		url: URL?,
		isFromCurrentUser: Bool,
		onButtonAction: @escaping () -> Void
	) {
		self.shortDate = shortDate
		self.name = name
		self.phone = phone
		self.url = url
		self.isFromCurrentUser = isFromCurrentUser
		self.onButtonAction = onButtonAction
	}

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				HStack(spacing: 12) {
					AsyncImage(
						url: url,
						placeholder: { ShimmerView().frame(width: 40, height: 40) },
						result: { Image(uiImage: $0).resizable() }
					)
					.scaledToFill()
					.frame(width: 40, height: 40)
					.clipped()
					.cornerRadius(20)

					VStack(alignment: .leading, spacing: 0) {
						Text(name)
							.font(.semibold(15))
							.foreground(.black())
						Spacer()
						Text(phone ?? "-")
							.font(.regular(13))
							.foreground(.darkGray())
					}
					Spacer()
				}
				.frame(height: 40)

				Button(action: {
					onButtonAction()
				}, label: {
					Text("Просмотр контакта")
						.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44, alignment: .center)
						.font(.bold(15))
						.foreground(.blue())
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color(.blue()), lineWidth: 1)
						)
				})
				.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44, alignment: .center)
				.padding(.top, 12)

				Spacer()
			}
			.padding(.top, 8)
			.padding(.horizontal, 16)
			CheckTextReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
		}
		.frame(width: 244, height: 138)
	}
}
