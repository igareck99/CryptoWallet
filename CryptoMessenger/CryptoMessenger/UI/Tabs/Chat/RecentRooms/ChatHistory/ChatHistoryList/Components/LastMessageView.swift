import SwiftUI

// MARK: - LastMessageData

struct LastMessageData: Identifiable, ViewGeneratable {

    var id = UUID()
    let messageType: MessageType
    let isFromCurrentUser: Bool
    let unreadedEvents: Int
    let isPinned: Bool
    
    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        LastMessageDataView(data: self).anyView()
    }
}

// MARK: - LastMessageDataView

struct LastMessageDataView: View {
    
    let data: LastMessageData
    @State var showLocationTransition = false
    
    var body: some View {
        HStack(alignment: .bottom) {
            content()
            Spacer()
            unreadEventsCountView()
                .padding(.trailing, 16)
                .padding(.top, 12)
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        switch data.messageType {
        case let .text(text):
            Text(text, [.font(.regular(15)),
                        .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                        .color(Color(.custom(.init( 133, 135, 141)))) ] ).lineLimit(2)
        case let .image(url):
            AnyView(
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
                            .color(Color(.custom(.init( 133, 135, 141))))
                        ]
                    )
                }
            )
        case let .file(fileName, url):
            AnyView(
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
                        .color(Color(.custom(.init( 133, 135, 141))))
                    ])
                }
            )
        case let .contact(_, _, url):
            AnyView(
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
                            .color(Color(.custom(.init( 133, 135, 141))))
                        ]
                    )
                }
            )
        case let .location((longitute, latitude)):
            AnyView(
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
                            .color(Color(.custom(.init( 133, 135, 141))))
                        ]
                    )
                }
            )
        case .audio(_):
            AnyView(
                HStack(spacing: 6) {
                    R.image.chat.audio.microfoneImage.image
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(
                        "Голосовое сообщение",
                        [
                            .font(.regular(15)),
                            .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                            .color(Color(.custom(.init(133, 135, 141))))
                        ]
                    )
                }
            )
        case .video(_):
            AnyView(
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
                            .color(Color(.custom(.init( 133, 135, 141))))
                        ])
                }
            )
        case .call:
            AnyView(HStack(spacing: 6) {
                (!data.isFromCurrentUser ? Image(systemName: "phone") : Image(systemName: "phone.down"))
                    .resizable()
                    .foregroundColor(.romanSilver)
                    .frame(width: 14, height: 14)
                Text(
                    "Звонок",
                    [
                        .font(.regular(15)),
                        .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                        .color(Color(.custom(.init(133, 135, 141))))
                    ]
                )
            }
            )
        default:
            AnyView(EmptyView())
        }
    }
    
    @ViewBuilder
    private func unreadEventsCountView() -> some View {
        if data.unreadedEvents > 0 {
            ZStack(alignment: .center) {
                Circle()
                    .frame(height: 20, alignment: .center)
                    .foregroundColor(Color(.init(222, 38, 100)))
                    .cornerRadius(10)
                Text(data.unreadedEvents.description)
                    .font(.regular(14))
                    .foreground(.white)
            }
        } else {
            EmptyView()
        }
    }
}
