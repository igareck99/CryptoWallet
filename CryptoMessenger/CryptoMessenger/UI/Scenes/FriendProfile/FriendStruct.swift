import UIKit

struct Friend {
    var nickname: String
    var name: String
    var photo: UIImage!
    var links: [Int]
    var telephone: String
    var info: String

    init(nickname: String, name: String, links: [Int], telephone: String, info: String) {
        self.nickname = nickname
        self.name = name
        self.links = links
        self.telephone = telephone
        self.info = info
    }

    init(nickname: String, photo: UIImage!, name: String, links: [Int], telephone: String, info: String) {
        self.nickname = nickname
        self.photo = photo
        self.name = name
        self.links = links
        self.telephone = telephone
        self.info = info
    }
}

var profile1 = Friend(nickname: "@bastaaknogano", photo: R.image.friendProfile.photoNone(),
                      name: "Василий Вакуленко", links: [0, 1, 0, 1], telephone: "89511423367", info: "Баста & @_zivert - неболей\nbit.ly/neboley")
var profile2 = Friend(nickname: "@test", name: "Василий Вакуленко", links: [0,0,0,0],
                      telephone: "Номер скрыт", info: "Концерт скоро приходи")
