import UIKit

// MARK: - ProfileMainMenuItem

struct ProfileMainMenuItem: Identifiable {

    // MARK: - Internal Properties
    
    var id = UUID()
    var text: String
    var image: UIImage?
    var notifications: Int
    var type: Int = 0

    // MARK: - Static Methods

    static func getmenuItems() -> [ProfileMainMenuItem] {
        return [
            .init(text: R.string.localizable.additionalMenuProfile(),
                  image: R.image.additionalMenu.profile(), notifications: 0),
            .init(text: R.string.localizable.additionalMenuPersonalization(),
                  image: R.image.additionalMenu.personalization(), notifications: 0),
            .init(text: R.string.localizable.additionalMenuSecurity(),
                  image: R.image.additionalMenu.security(), notifications: 0),
            .init(text: R.string.localizable.additionalMenuWallet(),
                  image: R.image.additionalMenu.wallet(), notifications: 0),
            .init(text: R.string.localizable.additionalMenuNotification(),
                  image: R.image.additionalMenu.notifications(), notifications: 1),
            .init(text: R.string.localizable.additionalMenuChats(), image: R.image.additionalMenu.chat(),
                  notifications: 0),
            .init(text: R.string.localizable.additionalMenuData(), image: R.image.additionalMenu.dataStorage(),
                  notifications: 0),
            .init(text: R.string.localizable.additionalMenuQuestions(),
                  image: R.image.additionalMenu.answers(), notifications: 0),
            .init(text: R.string.localizable.additionalMenuAbout(),
                  image: R.image.additionalMenu.about(), notifications: 0)
        ]
    }
}
