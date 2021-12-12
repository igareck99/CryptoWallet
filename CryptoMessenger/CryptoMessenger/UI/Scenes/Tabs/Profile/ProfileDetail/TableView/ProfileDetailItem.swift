import UIKit

// MARK: - ProfileDetailItem

struct ProfileDetailItem {

    // MARK: - Internal Properties

    var image: UIImage?
    var status = ""
    var description = ""
    var name = ""
    var countryCode = ""
    var phone = UserCredentialsStorageService().userPhoneNumber

    // MARK: - Static Methods

    static func getProfile() -> ProfileDetailItem {
        return ProfileDetailItem(image: R.image.profileDetail.mainImage1(),
                                 status: "AURA Россия",
                                 description: "Делаю лучший крипто-мессенджер!\nЖиву в Зеленограде! Люблю качалку:)",
                                 name: "Артём Квач",
                                 countryCode: "+7  Россия",
                                 phone: "(925) 851-15-41")
    }
}
