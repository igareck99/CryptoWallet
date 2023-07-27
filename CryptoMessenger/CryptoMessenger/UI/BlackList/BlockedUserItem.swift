import SwiftUI

// MARK: - BlockedUserItem

struct BlockedUserItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var photo: UIImage!
    var name: String
    var status: String

    // MARK: - Static Methods

    static func blockedUsers() -> [BlockedUserItem] {
        let item1 = BlockedUserItem(photo: R.image.blackList.user1(),
                                    name: "Света Корнилова",
                                    status: "Привет, теперь я в Aura")
        let item2 = BlockedUserItem(photo: R.image.blackList.user2(),
                                    name: "Давид Гретхом",
                                    status: "Привет, теперь я в Aura")
        let item3 = BlockedUserItem(photo: R.image.blackList.user3(),
                                    name: "Кирилл П.",
                                    status: "Привет, теперь я в Aura")
        let sessions_list = [item1, item2, item3]
        return sessions_list
    }
}
