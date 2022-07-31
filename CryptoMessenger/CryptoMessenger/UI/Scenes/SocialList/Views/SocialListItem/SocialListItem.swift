import SwiftUI

// MARK: - SocialListItem

struct SocialListItem: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
	var fullUrl: String {
		guard let baseUrl = SocialNetworkType.baseUrlsByType[socialType] else { return "" }
		return url.lowercased().contains(baseUrl.lowercased()) ? url : baseUrl + url
	}
    var url: String
    var sortOrder: Int
    let socialType: SocialNetworkType

	init(
		url: String = "",
		sortOrder: Int,
		socialType: SocialNetworkType
	) {
		self.url = url
		self.sortOrder = sortOrder
		self.socialType = socialType
	}

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
		return [
			"sort_order": item.sortOrder,
			"social_type": item.socialType,
			"url": item.url
		]
    }
}
