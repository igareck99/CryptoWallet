import UIKit

// MARK: - SessionItem

struct SessionItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var photo: UIImage!
    var device_id: String
    var device: String
    var place: String
    var date: String
    var ip: String

    // MARK: - Static Methods

    static func sessionsInfo() -> SessionItem {
        let item1 = SessionItem( photo: R.image.session.ios(),
                                 device_id: "TESTID",
                                 device: "iPhone",
                                 place: "Москва, Россия",
                                 date: "сегодня в 14:11",
                                 ip: "46.242.16.24")
        return item1
    }
}

// MARK: - SessionInfoItem

struct SessionInfoItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: String
    var info: String
}
