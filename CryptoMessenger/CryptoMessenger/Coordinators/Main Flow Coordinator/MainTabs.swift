import SwiftUI

enum MainTabs: Int, Hashable {

    case chat = 0
    case wallet = 1
    case profile = 2

    var image: Image {
        switch self {
        case .chat:
            return R.image.tabBar.chat.image
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
            return R.image.tabBar.wallet.image
        case .profile:
                return R.image.tabBar.profile.image
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
