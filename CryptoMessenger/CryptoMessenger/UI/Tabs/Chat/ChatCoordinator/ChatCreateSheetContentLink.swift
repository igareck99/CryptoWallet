import SwiftUI

enum ChatCreateSheetContentLink: Hashable, Identifiable {

    case selectContact(ChatCreateFlowCoordinatorProtocol)
    case createContact(ChatCreateFlowCoordinatorProtocol)
    case createChannel(ChatCreateFlowCoordinatorProtocol)
    case createGroupChat(ChatData, ChatCreateFlowCoordinatorProtocol)
    case createChat(coordinator: ChatCreateFlowCoordinatorProtocol)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatCreateSheetContentLink, rhs: ChatCreateSheetContentLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
