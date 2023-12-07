import Foundation

protocol PushNotificationRouterable {

}

final class PushNotificationRouter<
    ChatTabState: ChatsRouterStatable,
    WalletTabState: WalletRouterStatable,
    ProfileTabState: ProfileRouterStatable
> {

    private let chatsTabState: ChatTabState
    private let walletTabState: WalletTabState
    private let profileTabState: ProfileTabState

    init(
        chatsTabState: ChatTabState = ChatsRouterState.shared,
        walletTabState: WalletTabState = WalletRouterState.shared,
        profileTabState: ProfileTabState = ProfileRouterState.shared
    ) {
        self.chatsTabState = chatsTabState
        self.walletTabState = walletTabState
        self.profileTabState = profileTabState
    }
}

// MARK: - PushNotificationRouterable

extension PushNotificationRouter: PushNotificationRouterable {

}
