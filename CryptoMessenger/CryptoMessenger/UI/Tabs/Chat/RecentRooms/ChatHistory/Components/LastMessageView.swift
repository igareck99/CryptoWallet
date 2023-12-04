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
            Text(text)
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .lineLimit(2)
                .foreground(.romanSilver)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
        case let .image(url):
            HStack(spacing: 6) {
                AsyncImage(
                    defaultUrl: url,
                    placeholder: {
                        ShimmerView()
                            .frame(width: 16, height: 16)
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 16, height: 16)
                .cornerRadius(2)
                Text("Фото")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
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
                Text(fileName)
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        case let .contact(_, _, url):
            HStack(spacing: 6) {
                AsyncImage(
                    defaultUrl: url,
                    placeholder: {
                        ShimmerView()
                            .frame(width: 16, height: 16)
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 16, height: 16)
                .cornerRadius(2)

                Text("Контакт")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        case let .location((longitute, latitude)):
            HStack(spacing: 6) {
                MapView(
                    place: Place(name: "", latitude: longitute, longitude: latitude),
                    showLocationTransition: $showLocationTransition
                )
                .scaledToFill()
                .frame(width: 16, height: 16)
                .cornerRadius(2)
                Text("Мес")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        case .audio(_):
            HStack(spacing: 6) {
                R.image.chat.audio.microfoneImage.image
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Голосовое сообщение")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        case .video(_):
            HStack(spacing: 6) {
                Image(systemName: "video.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)
                Text("Видео")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        case .call:
            HStack(spacing: 6) {
            (!data.isFromCurrentUser ? Image(systemName: "phone") : Image(systemName: "phone.down"))
                .resizable()
                .foregroundColor(.romanSilver)
                .frame(width: 16, height: 16)
            Text("Звонок")
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
            }
        case .sendCrypto:
            HStack(spacing: 6) {
                R.image.transaction.transfer.image
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)
                Text("Транзакция")
                    .font(.subheadlineRegular15)
                    .foregroundColor(.romanSilver)
            }
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func unreadEventsCountView() -> some View {
        if data.unreadedEvents > 0 {
            ZStack(alignment: .center) {
                Circle()
                    .frame(height: 20, alignment: .center)
                    .foregroundColor(Color.spanishCrimson)
                    .cornerRadius(10)
                Text(data.unreadedEvents.description)
                    .font(.subheadline2Regular14)
                    .foreground(.white)
            }
        } else {
            EmptyView()
        }
    }
}
