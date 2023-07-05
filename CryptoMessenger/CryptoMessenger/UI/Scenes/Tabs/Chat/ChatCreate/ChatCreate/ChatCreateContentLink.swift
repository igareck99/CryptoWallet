import SwiftUI

// MARK: - ChatCreateContentLink

enum ChatCreateContentLink: Identifiable, Hashable {

    case selectContact(Binding<ChatData>, ChatCreateFlowCoordinatorProtocol)
    case createContact
    case createChannel(ChatCreateFlowCoordinatorProtocol)
    case createGroupChat(Binding<ChatData>, ChatCreateFlowCoordinatorProtocol)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatCreateContentLink, rhs: ChatCreateContentLink) -> Bool {
        return rhs.id > lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
