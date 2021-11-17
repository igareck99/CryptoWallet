import UIKit

struct SessionItem: Identifiable {
    var id: Int
    var photo: UIImage!
    var device: String
    var place: String
    var date: String

    static func sessions() -> [SessionItem] {
        let item1 = SessionItem(id: 1, photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Москва, Россия",
                                date: "сегодня в 14:11")
        let item2 = SessionItem(id: 2, photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Стамбул, Турция",
                                date: "вчера в 10:09")
        let item3 = SessionItem(id: 3, photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Тбилиси, Грузия",
                                date: "23 октября в 11:45")
        let item4 = SessionItem(id: 4, photo: R.image.session.iphone(),
                                device: "iPhone",
                                place: "Баутми, Грузия",
                                date: "20 октября в 11:47")
        return [item1, item2, item3, item4]
    }
}
