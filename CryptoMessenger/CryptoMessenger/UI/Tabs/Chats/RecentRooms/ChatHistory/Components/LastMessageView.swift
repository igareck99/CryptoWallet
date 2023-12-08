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
                .lineLimit(1)
        case .image(_):
            lastEventView(
                text: "Изображение",
                systemImageName: .cameraFill
            )
        case let .file(_, _):
            lastEventView(
                text: "Файл",
                systemImageName: .docFill
            )
        case .contact(_, _, _):
            lastEventView(
                text: "Контакт",
                systemImageName: .userCropCircle
            )
        case .location(_):
            lastEventView(
                text: "Геопозиция",
                systemImageName: .locationFill
            )
        case .audio(_):
            lastEventView(
                text: "Голосовое сообщение",
                systemImageName: .micFill
            )
        case .video(_):
            lastEventView(
                text: "Видео",
                systemImageName: .videoFill
            )
        case .call:
            lastEventView(
                text: data.isFromCurrentUser ? "Исходящий звонок" : "Входящий звонок",
                systemImageName: data.isFromCurrentUser ? .phoneUpRightFill : .phoneDownLeftFill
            )
        case .sendCrypto:
            lastEventView(
                text: "Транзакция",
                image: R.image.transaction.transfer.image
            )
        default:
            EmptyView()
        }
    }

    private func lastEventView(text: String, systemImageName: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.romanSilver)
                .frame(width: 16, height: 16)
            Text(text)
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .lineLimit(1)
        }
        .padding(.top, 4)
    }

    private func lastEventView(text: String, image: Image) -> some View {
        HStack(spacing: 2) {
            image
                .resizable()
                .scaledToFit()
                .foregroundColor(.romanSilver)
                .frame(width: 16, height: 16)
            Text(text)
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .lineLimit(1)
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
