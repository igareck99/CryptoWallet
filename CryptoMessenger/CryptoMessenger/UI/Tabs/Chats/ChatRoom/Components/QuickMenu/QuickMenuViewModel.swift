import Foundation

// MARK: - QuickMenuViewModel

final class QuickMenuViewModel: ObservableObject {

    // MARK: - Internal Properties

    let messageType: MessageType
    let hasReactions: Bool
    let hasAccessToWrite: Bool
    let isFromCurrentUser: Bool
    let isChannel: Bool
    let userRole: ChannelRole
    let onAction: GenericBlock<QuickActionCurrentUser>
    let onReaction: GenericBlock<String>
    @Published var items: [QuickActionItem] = []
    @Published var height: CGFloat = 0

    init(messageType: MessageType, hasReactions: Bool,
         hasAccessToWrite: Bool, isChannel: Bool,
         isFromCurrentUser: Bool, userRole: ChannelRole,
         onAction: @escaping GenericBlock<QuickActionCurrentUser>,
         onReaction: @escaping GenericBlock<String>) {
        self.messageType = messageType
        self.hasReactions = hasReactions
        self.hasAccessToWrite = hasAccessToWrite
        self.isChannel = isChannel
        self.isFromCurrentUser = isFromCurrentUser
        self.userRole = userRole
        self.onAction = onAction
        self.onReaction = onReaction
        self.initData()
        self.computeHeight()
    }
    
    // MARK: - Private Methods
    
    private func computeHeight() {
        height = CGFloat(55 + 21 + 52 * items.count)
    }
    
    private func initData() {
        switch messageType {
        case .text(_):
            var actions: [QuickActionItem] = initCurrentUserActions()
            self.items = actions
        case .file(_, _), .video(_), .image(_), .audio(_):
            var actions: [QuickActionItem] = initCurrentUserActions(false, false)
            if hasReactions {
                actions.insert(QuickActionItem(action: .reaction), at: 2)
            }
            self.items = actions
        case .contact(name: _, phone: _, url: _), .sendCrypto, .location((_, _)):
            var actions: [QuickActionItem] = [QuickActionItem(action: .reply),
                                              // QuickActionItem(action: .addReaction),
                                              QuickActionItem(action: .delete)]
            self.items = actions
        default:
            break
        }
    }
    
    private func initCurrentUserActions(_ editable: Bool = true,
                                        _ copied: Bool = false) -> [QuickActionItem] {
        var actions: [QuickActionItem] = []
        if hasAccessToWrite {
            actions.append(QuickActionItem(action: .reply))
        }
        if isFromCurrentUser && editable {
            actions.append(QuickActionItem(action: .edit))
        }
        if copied {
            actions.append(QuickActionItem(action: .copy))
        }
        //actions.append(QuickActionItem(action: .addReaction))
        if isFromCurrentUser {
            actions.append(QuickActionItem(action: .delete))
        }
        return actions
    }
}
