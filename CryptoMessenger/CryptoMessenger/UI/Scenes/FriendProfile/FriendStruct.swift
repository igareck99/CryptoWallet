import UIKit

struct Friend {
    var nickname: String
    var name: String
    var photo: UIImage
    var links: [Int]
    var telephone: String
    var info: String
    var images: [UIImage]
    var advertisement: String

    init(nickname: String,
         name: String,
         links: [Int],
         photo: UIImage! = R.image.friendProfile.photoNone(),
         telephone: String = "Номер скрыт",
         info: String, images: [UIImage] = [],
         advertisement: String = "") {
        self.nickname = nickname
        self.photo = photo
        self.name = name
        self.links = links
        self.telephone = telephone
        self.info = info
        self.images = images
        self.advertisement = advertisement
    }
}

var profile1 = Friend(nickname: "@bastaaknogano",
                      name: "Василий Вакуленко",
                      links: [0, 1, 0, 1],
                      photo: R.image.friendProfile.photoNone(),
                      info: "Баста & @_zivert - неболей\nbit.ly/neboley",
                      images: [R.image.profile.testpicture2()!,
                               R.image.profile.testpicture3()!,
                               R.image.profile.testpicture4()!,
                               R.image.profile.testpicture5()!],
                      advertisement: "Концерт 5 октября. Не забыть купить билеты! Это мероприятие очень важное для нас")
