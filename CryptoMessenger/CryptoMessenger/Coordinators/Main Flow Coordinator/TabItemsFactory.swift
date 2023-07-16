import SwiftUI

protocol TabItemsFactoryProtocol {
    static func makeChatTabModel(chateDelegate: ChatHistorySceneDelegate) -> TabItemModel

    static func makeWalletTabModel() -> TabItemModel

    static func makeProfileTabModel(profileDelegate: ProfileSceneDelegate) -> TabItemModel
}

enum TabItemsFactory: TabItemsFactoryProtocol {
    static func makeChatTabModel(chateDelegate: ChatHistorySceneDelegate) -> TabItemModel {
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

    static func makeProfileTabModel(profileDelegate: ProfileSceneDelegate) -> TabItemModel {
        TabItemModel(
            title: MainTabs.profile.text,
            icon: MainTabs.profile.image,
            tabType: .profile
        ) {
            ProfileAssembly.build().anyView()
        }
    }
}
