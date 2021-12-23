import SwiftUI

// MARK: - SocialListItem

struct SocialListItem: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var url: String
    var type: SocialItemType
    let networkType: SocialNetworkType

    // MARK: - Static Methods

    static func socialList() -> [SocialListItem] {
        let item1 = SocialListItem(url: "https://twitter.com/?lang=ru",
                                   type: .show,
                                   networkType: .twitter)
        let item2 = SocialListItem(url: "https://www.instagram.com/igareck99/",
                                   type: .show,
                                   networkType: .instagram
        )
        let item3 = SocialListItem(url: "https://github.com/igareck99",
                                   type: .show,
                                   networkType: .webSite)
        let item4 = SocialListItem(url: "facebook.com/arestov_lv",
                                   type: .notShow,
                                   networkType: .facebook)
        let social_List = [item1, item3, item2, item4]
        return social_List
    }
}

// MARK: - SocialItemType

enum SocialItemType {

    // MARK: - Types

    case show
    case notShow
}

// MARK: - SocialNetworkType

enum SocialNetworkType {

    // MARK: - Types

    case twitter
    case facebook
    case telegram
    case webSite
    case instagram
}
