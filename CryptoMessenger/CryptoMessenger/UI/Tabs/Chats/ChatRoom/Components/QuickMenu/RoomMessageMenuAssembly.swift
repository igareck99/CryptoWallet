import SwiftUI

// MARK: - RoomMessageMenuAssembly

enum RoomMessageMenuAssembly {
    static func build(
        messageType: MessageType,
        hasReactions: Bool,
        hasAccessToWrite: Bool,
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: @escaping GenericBlock<QuickActionCurrentUser>,
        onReaction: @escaping GenericBlock<String>
    ) -> some View {
        let viewModel = QuickMenuViewModel(messageType: messageType,
                                           hasReactions: hasReactions,
                                           hasAccessToWrite: hasAccessToWrite,
                                           isChannel: isChannel,
                                           isFromCurrentUser: isCurrentUser,
                                           userRole: userRole,
                                           onAction: onAction,
                                           onReaction: onReaction)
        let view = QuickMenuView(viewModel: viewModel)
        return view
    }
}
