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
            return R.image.socialNetworks.facebookIcon.image
        case .twitter:
            return R.image.socialNetworks.twitterIcon.image
        case .instagram:
            return R.image.socialNetworks.instagramIcon.image
        case .linkedin:
            return R.image.socialNetworks.linkedinIcon.image
        case .vk:
            return R.image.socialNetworks.vkIcon.image
        case .tiktok:
            return R.image.socialNetworks.tiktokIcon.image
        }
    }

    // MARK: - Static methods

    static func getDict(item: SocialListItem) -> [String: Any] {
        let dict: [String: Any] = ["sort_order": item.sortOrder,
                                      "social_type": item.socialType,
                                      "url": item.url]
        return dict
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

    var description: String {
        switch self {
        case .facebook:
            return "facebook"
        case .twitter:
            return "twitter"
        case .vk:
            return "vk"
        case .instagram:
            return "instagram"
        case .tiktok:
            return "tiktok"
        case .linkedin:
            return "linkedin"
        }
    }

    static func networkType(item: String) -> SocialNetworkType {
        switch item {
        case "facebook":
            return SocialNetworkType.facebook
        case "twitter":
            return SocialNetworkType.twitter
        case "vk":
            return SocialNetworkType.vk
        case "instagram":
            return SocialNetworkType.instagram
        case "tiktok":
            return SocialNetworkType.tiktok
        case "linkedin":
            return SocialNetworkType.linkedin
        default:
            return SocialNetworkType.facebook
        }
    }
}
