import SwiftUI

// MARK: - ChatHistoryContentLink

enum ChatHistoryContentLink: Hashable, Identifiable {

    case chatRoom(room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)
    case chatHistrory
    case channelSettings(roomId: String,
                         isLeaveChannel: Binding<Bool>,
                         chatData: Binding<ChatData>,
                         saveData: Binding<Bool>,
                         coordinator: ChatHistoryFlowCoordinatorProtocol)
    case chatSettings(Binding<ChatData>, Binding<Bool>, Binding<Bool>, AuraRoom, ChatHistoryFlowCoordinatorProtocol)
    case chatMedia(room: AuraRoom)
    case friendProfile(contact: Contact)
    case adminList(chatData: Binding<ChatData>,
                   coordinator: ChatHistoryFlowCoordinatorProtocol)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatHistoryContentLink, rhs: ChatHistoryContentLink) -> Bool {
        return rhs.id > lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - ChatHistorySheetLink

enum ChatHistorySheetLink: Identifiable {

    var id: String {
        String(describing: self)
    }

    case createChat(chatData: Binding<ChatData>)
}
