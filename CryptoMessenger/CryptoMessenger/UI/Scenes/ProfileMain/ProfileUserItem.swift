import UIKit

// MARK: - ProfileUserItem

struct ProfileUserItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let image: UIImage?
    let nickname: String
    let status: String
    let info: String
    let name: String
    let code: String
    let number: String
    let photos: [UIImage?]

    // MARK: - Static Methods

    static func getProfile() -> ProfileUserItem {
        return ProfileUserItem(image: R.image.profileDetail.mainImage1(),
                               nickname: "@ikea_rus",
                               status: "AURA Россия",
                               info: "Делаю лучший крипто-мессенджер!\nЖиву в Зеленограде! Люблю качалку:)",
                               name: "Артём Квач",
                               code: "+7  Россия",
                               number: "(925) 851-15-41",
                               photos: [R.image.profile.testpicture2(),
                                        R.image.profile.testpicture5(),
                                        R.image.profile.testpicture3(),
                                        R.image.profile.testpicture4()]
        )
    }
}
