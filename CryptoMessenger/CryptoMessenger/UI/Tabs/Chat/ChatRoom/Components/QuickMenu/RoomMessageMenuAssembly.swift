import SwiftUI

// MARK: - RoomMessageMenuAssembly

enum RoomMessageMenuAssembly {
    
    static func build(_ isCurrentUser: Bool,
                      _ isChannel: Bool,
                      _ userRole: ChannelRole,
                      _ onAction: @escaping GenericBlock<QuickActionCurrentUser>,
                      _ onReaction: @escaping GenericBlock<String>) -> some View {
        let view = QuickMenuView(isCurrentUser: isCurrentUser,
                                 isChannel: isChannel,
                                 userRole: userRole,
                                 onAction: onAction,
                                 onReaction: onReaction).anyView()
        return view
    }
}
