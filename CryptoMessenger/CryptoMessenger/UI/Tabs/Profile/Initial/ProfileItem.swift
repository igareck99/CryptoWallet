import SwiftUI

struct ProfileItem: Identifiable {
    let id = UUID()
    var avatar: URL?
    var mxId: String = ""
    var name = "Имя не заполнено"
    var nickname = ""
    var nicknameDisplay = ""
    var status = "Всем привет! Я использую AURA!"
    var note = ""
    var info = ""
    var phone = "Номер не заполнен"
    var photos: [Image] = []
    var photosUrls: [URL] = []
    var socialNetwork = [SocialListItem]()
}
