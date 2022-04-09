import SwiftUI

// MARK: - QuickAction

enum QuickAction: CaseIterable {

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
            return "Ответить"
        case .edit:
            return "Редактировать"
        case .copy:
            return "Скопировать"
        case .favorite:
            return "В Избранное"
        case .forward:
            return "Переслать"
        case .reaction:
            return "Реакция"
        case .delete:
            return "Удалить сообщение"
        }
    }

    var color: Palette { self == .delete ? .red() : .blue() }

    var image: Image {
        switch self {
        case .reply:
            return R.image.chat.reaction.reply.image
        case .edit:
            return R.image.chat.reaction.edit.image
        case .copy:
            return R.image.chat.reaction.copy.image
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

// MARK: - QuickMenuView

struct QuickMenuView: View {

    // MARK: - QuickActionItem

    struct QuickActionItem: Identifiable {

        // MARK: - Internal Properties

        let id = UUID()
        let action: QuickAction
    }

    // MARK: - Internal Properties

    @Binding var cardPosition: CardPosition
    let onAction: GenericBlock<QuickAction>

    // MARK: - Private Properties

    private let actions: [QuickActionItem] = QuickAction.allCases.map { .init(action: $0) }
    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(actions, id: \.id) { item in
                HStack {
                    HStack {
                        item.action.image
                    }
                    .frame(width: 40, height: 40)
                    .background(item.action == .delete ? Color(.red(0.1)) : Color(.blue(0.1)))
                    .cornerRadius(20)

                    Text(item.action.title)
                        .font(.regular(17))
                        .foreground(item.action == .delete ? .red() : .blue())
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
        }.id(UUID())
    }
}
