import SwiftUI

// MARK: - SocialListItem

struct SocialListItem: Identifiable, Equatable {

    // MARK: - Internal Properties

    var id = UUID()
    var url: String
    var type: SocialItemType
    var networkType: SocialNetworkType

    // MARK: - Static Methods

    static func socialList() -> [SocialListItem] {
        let item1 = SocialListItem(url: "twitter.com/arestov_lv",
                                   type: .show,
                                   networkType: .twitter)
        let item2 = SocialListItem(url: "facebook.com/arestov_design",
                                   type: .show,
                                   networkType: .facebook)
        let item4 = SocialListItem(url: "telegram.com/arestov_lv",
                                   type: .show,
                                   networkType: .telegram)
        let item3 = SocialListItem(url: "instagram.com/arestov_design",
                                   type: .notShow,
                                   networkType: .instagram
        )
        let social_List = [item1, item2, item3, item4]
        return social_List
    }
}

// MARK: - SocialItemType

enum SocialItemType {
    case show
    case notShow
}

// MARK: - SocialNetworkType

enum SocialNetworkType {
    case twitter
    case facebook
    case telegram
    case webSite
    case instagram
}
