import SwiftUI

protocol TabItemsViewModelProtocol: ObservableObject {
    var tabs: [TabItemModel] { get }
}

final class TabItemsViewModel {

    var tabs = [TabItemModel]()
    private let toggles: MainFlowTogglesFacadeProtocol
    private let factory: TabItemsFactoryProtocol.Type
    private let onlogout: () -> Void

    init (
        toggles: MainFlowTogglesFacadeProtocol,
        factory: TabItemsFactoryProtocol.Type,
        onlogout: @escaping () -> Void
    ) {
        self.toggles = toggles
        self.factory = factory
        self.onlogout = onlogout
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
            factory.makeProfileTabModel(onlogout: onlogout)
        )
        return tabItems
    }
}

// MARK: - TabItemsViewModelProtocol

extension TabItemsViewModel: TabItemsViewModelProtocol {}
