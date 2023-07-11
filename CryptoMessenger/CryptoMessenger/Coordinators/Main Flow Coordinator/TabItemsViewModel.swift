import SwiftUI

protocol TabItemsViewModelProtocol: ObservableObject {
    var tabs: [TabItemModel] { get }
}

final class TabItemsViewModel {

    var tabs = [TabItemModel]()
    private var chateDelegate: ChatHistorySceneDelegate
    private var profileDelegate: ProfileSceneDelegate
    private let toggles: MainFlowTogglesFacadeProtocol
    private let factory: TabItemsFactoryProtocol.Type

    init (
        chateDelegate: ChatHistorySceneDelegate,
        profileDelegate: ProfileSceneDelegate,
        toggles: MainFlowTogglesFacadeProtocol,
        factory: TabItemsFactoryProtocol.Type
    ) {
        self.chateDelegate = chateDelegate
        self.profileDelegate = profileDelegate
        self.toggles = toggles
        self.factory = factory
        self.tabs = prepareTabs()
    }

    private func prepareTabs() -> [TabItemModel] {

        var tabItems: [TabItemModel] = [
            factory.makeChatTabModel(chateDelegate: chateDelegate)
        ]

        if toggles.isWalletAvailable {
            tabItems.append(
                factory.makeWalletTabModel()
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
