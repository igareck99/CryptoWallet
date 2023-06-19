import SwiftUI

// MARK: - MainFlowView

struct MainFlowView<Content: View>: View {

    @State private var selectedItem = MainTabs.chat
    //var chatHistoryView: ChatHistoryView<ChatHistoryViewModel>
    let chatHistoryView: () -> Content
    let walletView: () -> Content
    let profileView: () -> Content

    init(
        chatHistoryView: @escaping  () -> Content,
        walletView: @escaping  () -> Content,
        profileView: @escaping  () -> Content
    ) {
        self.chatHistoryView = chatHistoryView
        self.walletView = walletView
        self.profileView = profileView
    }

    var body: some View {
        content
    }

    private var content: some View {
        TabView(selection: $selectedItem) {
            chatHistoryView()
                .tabItem {
                    Label {
                        Text(MainTabs.chat.text)
                    } icon: {
                        selectedItem == MainTabs.chat ? MainTabs.chat.imageSelected :  MainTabs.chat.image
                    }
                }
                .tag(MainTabs.chat)
            walletView()
                .tabItem {
                    Label {
                        Text(MainTabs.wallet.text)
                    } icon: {
                        selectedItem == MainTabs.wallet ? MainTabs.wallet.imageSelected :  MainTabs.wallet.image
                    }
                }
                .tag(MainTabs.wallet)
            profileView()
                .tabItem {
                    Label {
                        Text(MainTabs.profile.text)
                    } icon: {
                        selectedItem == MainTabs.profile ? MainTabs.profile.imageSelected :  MainTabs.profile.image
                    }
                }
                .tag(MainTabs.profile)
        }
    }
}

// MARK: - MainTabs

enum MainTabs: Int, Hashable {

    // MARK: - Types

    case chat = 0
    case wallet = 1
    case profile = 2

    // MARK: - Internal Properties

    var image: Image {
        switch self {
        case .chat:
            return R.image.tabBar.chatGray.image
        case .wallet:
            return R.image.tabBar.wallet.image
        case .profile:
            return R.image.tabBar.profile.image
        }
    }

    var imageSelected: Image {
        switch self {
        case .chat:
            return R.image.tabBar.chat.image
        case .wallet:
            return R.image.tabBar.blueWallet.image
        case .profile:
            return R.image.tabBar.blueProfile.image
        }
    }

    var text: String {
        switch self {
        case .chat:
            return R.string.localizable.tabChat()
        case .wallet:
            return R.string.localizable.tabWallet()
        case .profile:
            return R.string.localizable.tabProfile()
        }
    }
}
