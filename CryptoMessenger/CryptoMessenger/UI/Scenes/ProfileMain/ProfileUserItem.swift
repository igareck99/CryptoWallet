import UIKit

// MARK: - ProfileUserItem

struct ProfileUserItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var image: UIImage?
    var nickname: String
    var status: String
    var info: String
    var name: String
    var code: String
    var number: String

    // MARK: - Static Methods

    static func getProfile() -> ProfileUserItem {
        return ProfileUserItem(image: R.image.profileDetail.mainImage1(),
                               nickname: "@ikea_rus",
                               status: "AURA Россия",
                               info: "Делаю лучший крипто-мессенджер!\nЖиву в Зеленограде! Люблю качалку:)",
                               name: "Артём Квач",
                               code: "+7  Россия",
                               number: "(925) 851-15-41")
    }
}
