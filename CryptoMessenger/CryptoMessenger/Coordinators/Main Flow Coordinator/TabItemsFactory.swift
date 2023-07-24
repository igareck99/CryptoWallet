import SwiftUI

// MARK: - TabItemsFactoryProtocol

protocol TabItemsFactoryProtocol {
    static func makeChatTabModel() -> TabItemModel

    static func makeWalletTabModel() -> TabItemModel

    static func makeProfileTabModel() -> TabItemModel
}

// MARK: - TabItemsFactory(TabItemsFactoryProtocol)

enum TabItemsFactory: TabItemsFactoryProtocol {
    
    // MARK: - Static Methods
    
    static func makeChatTabModel() -> TabItemModel {
        TabItemModel(
            title: MainTabs.chat.text,
            icon: MainTabs.chat.image,
            tabType: .chat
        ) {
            ChatHistoryAssembly.build().anyView()
        }
    }

    static func makeWalletTabModel() -> TabItemModel {
        TabItemModel(
            title: MainTabs.wallet.text,
            icon: MainTabs.wallet.image,
            tabType: .wallet
        ) {
            WalletAssembly.build().anyView()
        }
    }

    static func makeProfileTabModel() -> TabItemModel {
        TabItemModel(
            title: MainTabs.profile.text,
            icon: MainTabs.profile.image,
            tabType: .profile
        ) {
            ProfileAssembly.build().anyView()
        }
    }
}
