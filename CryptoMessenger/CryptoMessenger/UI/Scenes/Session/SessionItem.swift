import UIKit

// MARK: - SessionItem

struct SessionItem: Identifiable, Equatable {

    // MARK: - Internal Properties

    var id = UUID()
    var photo: UIImage!
    var device: String
    var place: String
    var date: String
    var IP: String

    // MARK: - Static Methods

    static func sessions(id: Int = -1) -> [SessionItem] {
        let item1 = SessionItem( photo: R.image.session.iphone(),
                                 device: "iPhone",
                                 place: "Москва, Россия",
                                 date: "сегодня в 14:11",
                                 IP: "46.242.16.24")
        let item2 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Стамбул, Турция",
                                date: "вчера в 10:09",
                                IP: "46.242.16.24")
        let item3 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Тбилиси, Грузия",
                                date: "23 октября в 11:45",
                                IP: "46.242.16.24")
        let item4 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Баутми, Грузия",
                                date: "20 октября в 11:47",
                                IP: "46.242.16.24")
        var sessions_list = [item1, item2, item3, item4]
        if id == -1 {
            return sessions_list
        } else if id == -2 {
            return []
        } else {
            sessions_list.remove(at: id)
            return sessions_list
        }
    }

    static func sessionsInfo(id: Int) -> SessionItem {
        let item1 = SessionItem( photo: R.image.session.iphone(),
                                 device: "iPhone",
                                 place: "Москва, Россия",
                                 date: "сегодня в 14:11",
                                 IP: "46.242.16.24")
        let item2 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Стамбул, Турция",
                                date: "вчера в 10:09",
                                IP: "46.242.16.24")
        let item3 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Тбилиси, Грузия",
                                date: "23 октября в 11:45",
                                IP: "46.242.16.24")
        let item4 = SessionItem(photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Баутми, Грузия",
                                date: "20 октября в 11:47",
                                IP: "46.242.16.24")
        let sessions_list = [item1, item2, item3, item4]
        return sessions_list[ id - 1 ]
    }
}

// MARK: - SessionInfoItem

struct SessionInfoItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: String
    var info: String
}
