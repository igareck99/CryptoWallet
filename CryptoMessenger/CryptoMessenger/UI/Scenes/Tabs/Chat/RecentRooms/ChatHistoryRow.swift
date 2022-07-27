import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

    // MARK: - Internal Properties

    let room: AuraRoom

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                AsyncImage(
                    url: room.roomAvatar,
                    placeholder: {
                        ZStack {
                            Color(.lightBlue())
                            Text(room.summary.displayname?.firstLetter.uppercased() ?? "?")
                                .foreground(.white())
                                .font(.medium(26))
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)

                if room.isDirect {
                    ZStack {
                        Circle().fill(.white).frame(width: 16, height: 16)
                        Circle().fill(Color(room.isOnline ? .green() : .gray())).frame(width: 12, height: 12)
                    }.padding([.leading, .top], 48)
                }
            }
            .frame(width: 60, height: 60)

            VStack(spacing: 4) {
                HStack(spacing: 12) {
                    Text(room.summary.displayname?.firstUppercased ?? "",
                         [
                            .font(.semibold(15)),
                            .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                            .color(.black())
                        ]
                    )
                    Spacer()
                    Text(
                        Calendar.current.isDateInYesterday(room.summary.lastMessageDate)
                        || room.summary.lastMessageDate.is24HoursHavePassed
                        ? room.summary.lastMessageDate.dayAndMonthAndYear
                        : room.summary.lastMessageDate.hoursAndMinutes,
                        [
                            .font(.regular(13)),
                            .color(.black222222(0.6))
                        ]
                    )
                }
                .padding(.top, 9)

                HStack(spacing: 12) {
                    switch room.messageType {
                    case let .text(text):
                        Text(
                            text,
                            [
                                .font(.regular(15)),
                                .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                                .color(.black(0.6))
                            ]
                        ).lineLimit(2)
                    case let .image(url):
                        HStack(spacing: 6) {
                            AsyncImage(
                                url: url,
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
                                    .color(.black(0.6))
                                ]
                            )
                        }
                    case let .file(fileName, url):
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
                                .color(.black(0.6))
                            ])
                        }
                    case let .contact(_, _, url):
                        HStack(spacing: 6) {
                            AsyncImage(
                                url: url,
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
                                    .color(.black(0.6))
                                ]
                            )
                        }
                    case let .location((longitute, latitude)):
                        HStack(spacing: 6) {
                            MapView(place: Place(name: "", latitude: longitute, longitude: latitude))
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                            .cornerRadius(2)

                            Text(
                                "Мес",
                                [
                                    .font(.regular(15)),
                                    .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                                    .color(.black(0.6))
                                ]
                            )
                        }
                    case .audio(_):
                        HStack(spacing: 6) {
                            R.image.chat.audio.microfoneImage.image
                                .resizable()
                                .frame(width: 15,
                                       height: 15)
                            Text(
                                "Голосовое сообщение",
                                [
                                    .font(.regular(15)),
                                    .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                                    .color(.black(0.6))
                                ]
                            )
                        }
                    default:
                        EmptyView()
                    }

                    Spacer()

                    if room.summary.localUnreadEventCount > 0 {
                        HStack(alignment: .center) {
                            Text(room.summary.localUnreadEventCount.description)
                                .font(.regular(13))
                                .foreground(.white())
                                .padding([.leading, .trailing], 7)
                                .padding([.top, .bottom], 2)
                        }
                        .frame(height: 20, alignment: .center)
                        .background(.red())
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 2)
                Spacer()
                Rectangle().fill(Color(.grayE6EAED())).frame(height: 1)
            }
        }
        .frame(height: 80)
        .padding([.leading, .trailing], 16)
    }
}
