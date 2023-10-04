import SwiftUI

// MARK: - NotSendedMessageMenu

struct NotSendedMessageMenu: View {
    
    // MARK: - Internal Properties

    var item: RoomEvent
    var onTapItem: (NotSendedMessage, RoomEvent) -> Void

    // MARK: - Body

    var body: some View {
        ForEach(NotSendedMessage.allCases, id: \.self) { value in
            HStack(spacing: 16) {
                value.image
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(value.text)
                    .foreground(value.textColor)
                    .font(.calloutRegular16)
                Spacer()
            }
            .frame(height: 57)
            .padding(.leading, 16)
            .onTapGesture {
               onTapItem(value, item)
            }
        }
    }
}

// MARK: - NotSendedMessage

enum NotSendedMessage: CaseIterable {

    case resend
    case delete

    var image: Image {
        switch self {
        case .delete:
            return R.image.channelSettings.brush.image
        case .resend:
            return R.image.chat.resend.image
        }
    }

    var text: String {
        switch self {
        case .resend:
            return R.string.localizable.chatMenuViewResend()
        case .delete:
            return R.string.localizable.callListDelete()
        }
    }

    var textColor: Color {
        switch self {
        case .resend:
            return .black
        case .delete:
            return .red
        }
    }
}
