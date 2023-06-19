import SwiftUI

enum ChatHistoryContentLink: Hashable, Identifiable {
    static func == (lhs: ChatHistoryContentLink, rhs: ChatHistoryContentLink) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    case firstLink(text: AuraRoom)
    case createChat(chatData: Binding<ChatData>)

    var id: String {
        String(describing: self)
    }
}
