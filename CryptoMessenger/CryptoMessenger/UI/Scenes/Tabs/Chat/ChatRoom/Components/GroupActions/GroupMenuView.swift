import SwiftUI

// MARK: - GroupAction

enum GroupAction: CaseIterable, Identifiable {
    // MARK: - Types

    case edit
    case notifications
    case translate
    case search
    case users
    case share
    case blacklist
    case delete

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .edit:
            return "Редактировать"
        case .notifications:
            return "Выключить уведомления"
        case .translate:
            return "Переводить сообщения"
        case .search:
            return "Поиск сообщений"
        case .users:
            return "Пользователи группы"
        case .share:
            return "Поделиться чатом"
        case .blacklist:
            return "Черный список"
        case .delete:
            return "Удалить чат"
        }
    }

    var color: Palette { self == .delete || self == .blacklist ? .red() : .blue() }

    var image: Image {
        switch self {
        case .edit:
            return R.image.chat.groupMenu.edit.image
        case .notifications:
            return R.image.chat.groupMenu.notifications.image
        case .translate:
            return R.image.chat.groupMenu.translate.image
        case .search:
            return R.image.chat.groupMenu.search.image
        case .users:
            return R.image.chat.groupMenu.users.image
        case .share:
            return R.image.chat.groupMenu.share.image
        case .blacklist:
            return R.image.chat.groupMenu.blackList.image
        case .delete:
            return R.image.chat.groupMenu.delete.image
        }
    }
}

// MARK: - GroupMenuView

struct GroupMenuView: View {

    // MARK: - Internal Properties

    @Binding var action: GroupAction?
    @Binding var cardGroupPosition: CardPosition

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(GroupAction.allCases, id: \.id) { act in
                Button(action: {
                    vibrate()
                    action = act
                    cardGroupPosition = .bottom
                }, label: {
                    HStack {
                        HStack {
                            act.image
                        }
                        .frame(width: 40, height: 40)
                        .background(act.color.suColor.opacity(0.1))
                        .cornerRadius(20)

                        Text(act.title)
                            .font(.regular(17))
                            .foreground(act == .delete ? .red() : .blue())
                            .padding(.leading, 16)

                        Spacer()
                    }
                    .frame(height: 64)
                    .padding([.leading, .trailing], 16)
                })
                .frame(height: 64)
            }
        }
    }
}
