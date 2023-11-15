import SwiftUI

// MARK: - ChatData

struct ChatData {

    // MARK: - Internal Properties

    var title = ""
    var description = ""
    var image: UIImage?
    var contacts: [Contact] = []
    var showNotifications = false
    var media: [URL] = []
    var links: [URL] = []
    var documents: [URL] = []
    var admins: [Contact] = []
    var shareLink: URL?
    var isDirect = false
    var avatarUrl: URL?
    
    static func emptyObject() -> ChatData {
        return ChatData()
    }
}

// MARK: - Contact

struct Contact: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    let id = UUID()
    let mxId: String
    var avatar: URL?
    let name: String
    let status: String
    var phone: String
    var isAdmin = false
    var type: ChatCreateListType?
    var onTap: (Contact) -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ContactRow(contact: self).anyView()
    }
}

// MARK: - SelectContact

struct SelectContact: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    let id = UUID()
    let mxId: String
    let avatar: URL?
    let name: String
    let phone: String
    var isSelected: Bool
    var sourceType: SelectContactSourceType = .exist
    var onTap: (SelectContact) -> Void

    func view() -> AnyView {
        return SelectContactViewCell(data: self).anyView()
    }
}


enum SelectContactSourceType {
    case finded
    case exist
}
