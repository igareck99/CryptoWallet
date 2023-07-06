import SwiftUI

protocol TabItemsViewModelProtocol: ObservableObject {
    var tabs: [TabItemModel] { get }
}

final class TabItemsViewModel {

    lazy var tabs: [TabItemModel] = prepareTabs()

    private var chateDelegate: ChatHistorySceneDelegate
    private var profileDelegate: ProfileSceneDelegate
    private var walletDelegate: WalletSceneDelegate
    private var onTransactionEndHelper: TransactionEndHandler
    private let toggles: MainFlowTogglesFacadeProtocol
    private let factory: TabItemsFactoryProtocol.Type

    init (
        chateDelegate: ChatHistorySceneDelegate,
        profileDelegate: ProfileSceneDelegate,
        walletDelegate: WalletSceneDelegate,
        toggles: MainFlowTogglesFacadeProtocol,
        factory: TabItemsFactoryProtocol.Type,
        onTransactionEndHelper: @escaping TransactionEndHandler
    ) {
        self.chateDelegate = chateDelegate
        self.profileDelegate = profileDelegate
        self.walletDelegate = walletDelegate
        self.toggles = toggles
        self.factory = factory
        self.onTransactionEndHelper = onTransactionEndHelper
    }

    private func prepareTabs() -> [TabItemModel] {

        var tabItems: [TabItemModel] = [
            factory.makeChatTabModel(chateDelegate: chateDelegate)
        ]

        if toggles.isWalletAvailable {
            tabItems.append(
                factory.makeWalletTabModel(
                    walletDelegate: walletDelegate,
                    onTransactionEndHelper: onTransactionEndHelper
                )
            )
        }
        tabItems.append(
            factory.makeProfileTabModel(profileDelegate: profileDelegate)
        )
        return tabItems
    }
}

// MARK: - TabItemsViewModelProtocol

extension TabItemsViewModel: TabItemsViewModelProtocol {}
