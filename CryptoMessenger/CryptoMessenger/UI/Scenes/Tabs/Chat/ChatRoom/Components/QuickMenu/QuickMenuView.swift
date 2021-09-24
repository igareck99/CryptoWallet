import SwiftUI

// MARK: - QuickAction

enum QuickAction: CaseIterable, Identifiable {
    
    // MARK: - Types
    
    case reply
    case edit
    case copy
    case favorite
    case forward
    case reaction
    case delete
    
    // MARK: - Internal Properties
    
    var id: String { UUID().uuidString }
    
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
    
    var color: Palette {
        switch self {
        case .delete:
            return .red()
        default:
            return .blue()
        }
    }
    
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
    
    // MARK: - Internal Properties
    
    @Binding var action: QuickAction?
    @Binding var cardPosition: CardPosition
    
    // MARK: - Private Properties
    
    @State private var isShown = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(QuickAction.allCases, id: \.id) { act in
                Button(action: {
                    vibrate()
                    action = act
                    cardPosition = .bottom
                }, label: {
                    HStack {
                        HStack {
                            act.image
                        }
                        .frame(width: 40, height: 40)
                        .background(act == .delete ? Color(.red(0.1)) : Color(.blue(0.1)))
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
