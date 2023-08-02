import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

	let room: ChatHistoryData
    let isFromCurrentUser: Bool
	@State var showLocationTransition = false
    
	// MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				avatarView().padding(.init(top: 2, leading: 14, bottom: 0, trailing: 0))
				VStack(alignment: .leading, spacing: 0) {
					displayNameView()
					messageView()
					Spacer()
				}.padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
				Spacer()
				VStack(alignment: .trailing, spacing: 0) {
					dateView()
					if room.unreadedEvents > 0 {
						unreadEventsCountView().padding(.top, 14)
					}
					Spacer()
				}.padding(.init(top: 12, leading: 0, bottom: 0, trailing: 16))
			}.frame(height: 76)
            Divider()
                .foregroundColor(Color(.init(216, 216, 217)))
                .frame(height: 0.5)
                .padding(.leading, 88)
		}.frame(height: 76)
            .onTapGesture {
                room.onTap(room)
            }
            .onLongPressGesture {
                room.onLongPress(room)
            }
	}

	private func displayNameView() -> AnyView {
		AnyView(
			Text(
                room.roomName.firstUppercased,
				[ .font(.medium(16)),
				  .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
				  .color(.black()) ]
			)
		)
	}

	private func unreadEventsCountView() -> AnyView {
		AnyView(
			HStack {
				Text(room.unreadedEvents.description)
					.font(.regular(14))
					.foreground(.white())
					.padding([.leading, .trailing], 7)
					.padding([.top, .bottom], 2)
			}
				.frame(height: 20, alignment: .center)
				.background(Color(.init(222, 38, 100)))
				.cornerRadius(10)
		)
	}

	private func dateView() -> AnyView {
		AnyView(
			Text(
				Calendar.current.isDateInYesterday(room.lastMessageTime)
				|| room.lastMessageTime.is24HoursHavePassed
				? room.lastMessageTime.dayAndMonthAndYear
				: room.lastMessageTime.hoursAndMinutes,
				[
					.font(.regular(14)),
					.color(.custom(.init( 133, 135, 141)))
				]
			)
		)
	}

	private func avatarView() -> AnyView {
		AnyView(
			ZStack {
                AsyncImage(
					defaultUrl: room.roomAvatar,
					placeholder: {
						ZStack {
							Color(.lightBlue())
							Text(room.roomName.firstLetter.uppercased() ?? "?")
								.foreground(.white())
								.font(.bold(28))
						}.frame(width: 60, height: 60)
					},
					result: {
						Image(uiImage: $0)
					}
				)
				.frame(width: 60, height: 60)
				.cornerRadius(30)

				if room.isDirect {
					ZStack {
						Circle().fill(.white).frame(width: 16, height: 16)
						Circle().fill( Color(room.isOnline ? .init(39, 174, 96) : .init(216, 216, 216)))
							.frame(width: 12, height: 12)
					}.padding([.leading, .top], 48)
				}
			}.frame(width: 62, height: 62)
		)
	}

	private func messageView() -> AnyView {
		switch room.lastMessage {
		case let .text(text):
			return AnyView(
				Text(text, [ .font(.regular(15)),
							 .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
							 .color(.custom(.init( 133, 135, 141))) ] ).lineLimit(2)
			)
		case let .image(url):
			return AnyView(
				HStack(spacing: 6) {
                    AsyncImage(
						defaultUrl: url,
						placeholder: {
							ShimmerView().frame(width: 20, height: 20)
						},
						result: {
							Image(uiImage: $0).resizable()
						}
					)
					.scaledToFill()
					.frame(width: 16, height: 16)
					.cornerRadius(2)
					Text(
						"Фото",
						[
							.font(.regular(15)),
							.paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
							.color(.custom(.init( 133, 135, 141)))
						]
					)
				}
			)
		case let .file(fileName, url):
			return AnyView(
				HStack(spacing: 6) {
					if let url = url {
						PDFKitView(url: url)
							.frame(width: 16, height: 16)
							.cornerRadius(2)
					} else {
						ShimmerView()
							.frame(width: 16, height: 16)
							.cornerRadius(2)
					}

					Text(fileName, [
						.font(.regular(15)),
						.paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
						.color(.custom(.init( 133, 135, 141)))
					])
				}
			)
		case let .contact(_, _, url):
			return AnyView(
				HStack(spacing: 6) {
                    AsyncImage(
						defaultUrl: url,
						placeholder: {
							ShimmerView().frame(width: 20, height: 20)
						},
						result: {
							Image(uiImage: $0).resizable()
						}
					)
					.scaledToFill()
					.frame(width: 16, height: 16)
					.cornerRadius(2)

					Text(
						"Контакт",
						[
							.font(.regular(15)),
							.paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
							.color(.custom(.init( 133, 135, 141)))
						]
					)
				}
			)
		case let .location((longitute, latitude)):
			return AnyView(
				HStack(spacing: 6) {
					MapView(
						place: Place(name: "", latitude: longitute, longitude: latitude),
						showLocationTransition: $showLocationTransition
					)
					.scaledToFill()
					.frame(width: 16, height: 16)
					.cornerRadius(2)
					Text(
						"Мес",
						[
							.font(.regular(15)),
							.paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
							.color(.custom(.init( 133, 135, 141)))
						]
					)
				}
			)
		case .audio(_):
			return AnyView(
				HStack(spacing: 6) {
					R.image.chat.audio.microfoneImage.image
						.resizable()
						.frame(width: 15, height: 15)
					Text(
						"Голосовое сообщение",
						[
							.font(.regular(15)),
							.paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
							.color(.custom(.init(133, 135, 141)))
						]
					)
				}
			)
        case .video(_):
            return AnyView(
                HStack(spacing: 6) {
                    Image(systemName: "video.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 18, height: 10)
                    Text(
                        "Видео",
                        [
                            .paragraph(.init(lineHeightMultiple: 1.21, alignment: .left)),
                            .font(.regular(15)),
                            .color(.custom(.init( 133, 135, 141)))
                        ])
                }
            )
        case .call:
            return AnyView(HStack(spacing: 6) {
                (!isFromCurrentUser ? Image(systemName: "phone") : Image(systemName: "phone.down"))
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 14, height: 14)
                Text(
                    "Звонок",
                    [
                        .font(.regular(15)),
                        .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                        .color(.custom(.init(133, 135, 141)))
                    ]
                )
            }
            )
		default:
			return AnyView(EmptyView())
		}
	}
}
