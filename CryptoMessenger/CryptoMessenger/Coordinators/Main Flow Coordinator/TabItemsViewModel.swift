import SwiftUI

protocol TabItemsViewModelProtocol: ObservableObject {
    var tabs: [TabItemModel] { get }
}

final class TabItemsViewModel {

    var tabs = [TabItemModel]()
    private let toggles: MainFlowTogglesFacadeProtocol
    private let factory: TabItemsFactoryProtocol.Type

    init (
        toggles: MainFlowTogglesFacadeProtocol,
        factory: TabItemsFactoryProtocol.Type
    ) {
        self.toggles = toggles
        self.factory = factory
        self.tabs = prepareTabs()
    }

    private func prepareTabs() -> [TabItemModel] {

        var tabItems: [TabItemModel] = [
            factory.makeChatTabModel()
        ]

        if toggles.isWalletAvailable {
            tabItems.append(
                factory.makeWalletTabModel()
            )
        }
        tabItems.append(
            factory.makeProfileTabModel()
        )
        return tabItems
    }
}

// MARK: - TabItemsViewModelProtocol

extension TabItemsViewModel: TabItemsViewModelProtocol {}
