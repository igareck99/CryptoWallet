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

    var color: Palette {
        switch self {
        case .exit, .complain:
            return .red(0.1)
        default:
            return .blue(0.1)
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
                .color(.black()),
                .font(.regular(15)),
                .paragraph(.init(lineHeightMultiple: 1.09, alignment: .left))
            ])
                .frame(height: 64)
                .padding(.leading, 16)

            Spacer()
        }
        .frame(height: 64)
        .background(.white())
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
