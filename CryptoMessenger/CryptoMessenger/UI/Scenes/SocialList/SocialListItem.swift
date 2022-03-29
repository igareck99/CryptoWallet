import SwiftUI

// MARK: - SocialListItem

struct SocialListItem: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var url: String
    var sortOrder: Int
    let socialType: SocialNetworkType

    var socialNetworkImage: Image {
        switch socialType {
        case .facebook:
            return R.image.profile.facebook.image
        case .twitter:
            return R.image.profile.twitter.image
        case .instagram:
            return R.image.profile.instagram.image
        case .linkedin:
            return R.image.socialNetworks.linkedin.image
        case .vk:
            return R.image.socialNetworks.vk.image
        case .tiktok:
            return R.image.socialNetworks.tiktok.image
        }
    }
}

// MARK: - SocialNetworkType

enum SocialNetworkType {

    // MARK: - Types

    case twitter
    case facebook
    case vk
    case instagram
    case linkedin
    case tiktok
}
