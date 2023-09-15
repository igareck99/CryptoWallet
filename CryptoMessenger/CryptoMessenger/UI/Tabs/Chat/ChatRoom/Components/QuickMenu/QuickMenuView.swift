import SwiftUI

// MARK: - QuickMenuView

struct QuickMenuView: View {

    // MARK: - Internal Properties

    var isCurrentUser: Bool
    var isChannel: Bool
    var userRole: ChannelRole
    let onAction: GenericBlock<QuickActionCurrentUser>
    let onReaction: GenericBlock<String>

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ReactionsSelectView(onReaction: onReaction)
            .padding(.leading, 16)
            .padding(.trailing, 13)
            Divider()
                .padding(.top, 16)
            generateItems()
        }.id(UUID())
            .onAppear {
                print("gtijroepwqkjsdfdso")
            }
    }

    private func generateItems() -> some View {
        return ForEach(getItems(), id: \.id) { item in
            HStack {
                HStack {
                    item.action.image
                }
                .frame(width: 40, height: 40)
                .background(item.action == .delete ? Color.spanishCrimson01 : Color.dodgerTransBlue)
                .cornerRadius(20)

                Text(item.action.title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(item.action == .delete ? .spanishCrimson : .dodgerBlue)
                    .padding(.leading, 16)

                Spacer()
            }
            .frame(height: 64)
            .padding(.horizontal, 16)
            .onTapGesture {
                vibrate()
                onAction(item.action)
            }
        }
    }

    private func getItems() -> [QuickActionItem] {
        if isChannel {
            switch userRole {
            case .owner:
                return [QuickActionCurrentUser.reply, QuickActionCurrentUser.edit,
                        QuickActionCurrentUser.copy, QuickActionCurrentUser.reaction,
                        QuickActionCurrentUser.delete].map { .init(action: $0) }
            case .admin:
                return [QuickActionCurrentUser.copy, QuickActionCurrentUser.reaction,
                        QuickActionCurrentUser.reply, QuickActionCurrentUser.delete].map { .init(action: $0) }
            case .unknown:
                return []
            case .user:
                return [QuickActionCurrentUser.copy, QuickActionCurrentUser.reaction].map { .init(action: $0) }
            }
        }
        if isCurrentUser {
            return [QuickActionCurrentUser.reply, QuickActionCurrentUser.edit,
                           QuickActionCurrentUser.copy, QuickActionCurrentUser.reaction,
                           QuickActionCurrentUser.delete].map { .init(action: $0) }
        } else {
            return [QuickActionCurrentUser.reply, QuickActionCurrentUser.copy,
                    QuickActionCurrentUser.reaction].map { .init(action: $0) }
        }
    }
}

// MARK: - QuickActionItem

struct QuickActionItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let action: QuickActionCurrentUser
}

// MARK: - QuickActionCurrentUser

enum QuickActionCurrentUser: CaseIterable {

    // MARK: - Types

    case reply
    case edit
    case copy
    case favorite
    case forward
    case reaction
    case delete

    // MARK: - Internal Properties

    var title: String {
        switch self {
        case .reply:
            return R.string.localizable.quickMenuAnswer()
        case .edit:
            return R.string.localizable.quickMenuEdit()
        case .copy:
            return R.string.localizable.quickMenuCopy()
        case .favorite:
            return R.string.localizable.quickMenuFavourite()
        case .forward:
            return R.string.localizable.quickMenuForward()
        case .reaction:
            return R.string.localizable.quickMenuReaction()
        case .delete:
            return R.string.localizable.quickMenuDelete()
        }
    }

    var color: Color { self == .delete ? .spanishCrimson : .dodgerBlue }

    var image: Image {
        switch self {
        case .reply:
            return R.image.chat.reaction.reply.image
        case .copy:
            return R.image.chat.reaction.copy.image
        case .edit:
            return R.image.chat.reaction.edit.image
        case .favorite:
            return R.image.chat.reaction.favorite.image
        case .forward:
            return R.image.chat.reaction.forward.image
        case .reaction:
            return R.image.chat.reaction.reaction.image
        case .delete:
            return R.image.chat.reaction.delete.image
        }
    }
}

// MARK: - QiuckMenyViewSize

enum QiuckMenyViewSize {

    case fromCurrentUser
    case fromAnotherUser
    case channel

    static func size(_ isFromCurrentUser: Bool,
                     _ isChannel: Bool,
                     _ channelRole: ChannelRole) -> CGFloat {
        if isChannel {
            switch channelRole {
            case .owner:
                return 393
            case .admin:
                return 336
            case .user:
                return 279
            case .unknown:
                return 0
            }
        } else if isFromCurrentUser && !isChannel {
            return 393
        } else {
            return 279
        }
    }
}
