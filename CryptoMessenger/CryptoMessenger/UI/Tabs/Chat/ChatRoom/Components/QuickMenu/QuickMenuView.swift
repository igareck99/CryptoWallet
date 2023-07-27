import SwiftUI

// swiftlint:disable all

// MARK: - QuickMenuView

struct QuickMenuView: View {

    // MARK: - Internal Properties

    @Binding var cardPosition: CardPosition
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
            ReactionsSelectView(cardPosition: $cardPosition,
                                onReaction: onReaction)
            .padding(.leading, 16)
            .padding(.trailing, 13)
            Divider()
                .padding(.top, 16)
            generateItems()
        }.id(UUID())
    }

    private func generateItems() -> some View {
        return ForEach(getItems(), id: \.id) { item in
            HStack {
                HStack {
                    item.action.image
                }
                .frame(width: 40, height: 40)
                .background(item.action == .delete ? Color(.red(0.1)) : Color(.blue(0.1)))
                .cornerRadius(20)

                Text(item.action.title)
                    .font(.regular(17))
                    //.foreground(item.action == .delete ? .red() : .blue())
                    .padding(.leading, 16)

                Spacer()
            }
            .frame(height: 64)
            .padding(.horizontal, 16)
            .onTapGesture {
                vibrate()
                onAction(item.action)
                cardPosition = .bottom
            }
        }
    }

    private func getItems() -> [QuickActionItem] {
        if isChannel {
            switch userRole {
            case .owner, .admin:
                return [QuickActionCurrentUser.copy, QuickActionCurrentUser.reaction,
                        QuickActionCurrentUser.reply, QuickActionCurrentUser.edit,
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
            return QuickActionCurrentUser.allCases.map { .init(action: $0) }
        } else {
            return QuickActionCurrentUser.allCases.filter({ item in
                item != .edit
            }).map { .init(action: $0) }
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

    var color: Palette { self == .delete ? .red() : .blue() }

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
