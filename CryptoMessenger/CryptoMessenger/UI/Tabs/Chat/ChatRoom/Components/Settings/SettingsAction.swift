import SwiftUI

// MARK: - SettingsAction

enum SettingsAction: CaseIterable, Identifiable {

    // MARK: - Types

    case media, notifications, admins
    case share, exit, complain

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var image: Image {
        switch self {
        case .media:
            return R.image.chatSettings.media.image
        case .notifications:
            return R.image.chatSettings.notifications.image
        case .admins:
            return R.image.chatSettings.admins.image
        case .share:
            return R.image.chatSettings.share.image
        case .exit:
            return R.image.chatSettings.exit.image
        case .complain:
            return R.image.chatSettings.complain.image
        }
    }

    var title: String {
        switch self {
        case .media:
            return "Медиа, ссылки и документы"
        case .notifications:
            return "Уведомления"
        case .admins:
            return "Администраторы"
        case .share:
            return "Поделиться чатом"
        case .exit:
            return "Выйти из чата"
        case .complain:
            return "Пожаловаться на сообщение"
        }
    }

    var color: Color {
        switch self {
        case .exit, .complain:
            return .spanishCrimson01
        default:
            return .dodgerTransBlue
        }
    }
    
    var message: String {
        switch self {
        case .exit:
            return "Вы действительно хотите выйти из чата?"
        default:
            return ""
        }
    }

    var view: some View {
        HStack(spacing: 0) {
            HStack { image }
            .frame(width: 40, height: 40)
            .background(color)
            .cornerRadius(20)
            .padding([.top, .bottom], 12)

            Text(title, [
                .paragraph(.init(lineHeightMultiple: 1.09, alignment: .left))
            ])
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.chineseBlack)
                .frame(height: 64)
                .padding(.leading, 16)

            Spacer()
        }
        .frame(height: 64)
        .background(Color.white)
    }

    var alertItem: AlertItem? {
        switch self {
        case .exit:
            return .init(
                title: Text("Выйти из чата"),
                message: Text("Вы действительно хотите выйти из чата?"),
                primaryButton: .default(Text("Отменить")),
                secondaryButton: .default(Text("Выйти")) {  }
            )
        case .complain:
            return .init(
                title: Text("Пожаловаться на чат"),
                message: Text("Вы действительно хотите пожаловаться чат?"),
                primaryButton: .default(Text("Отменить")),
                secondaryButton: .default(Text("Хочу"))
            )
        default:
            return nil
        }
    }

}
