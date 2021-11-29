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
}
