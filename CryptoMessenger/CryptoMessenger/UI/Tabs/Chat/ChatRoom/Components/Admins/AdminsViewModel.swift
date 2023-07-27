import SwiftUI

// MARK: - AdminsViewModel

final class AdminsViewModel: ObservableObject {
    
    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    var coordinator: ChatHistoryFlowCoordinatorProtocol

    // MARK: - Lifecyle

    init(chatData: Binding<ChatData>,
         coordinator: ChatHistoryFlowCoordinatorProtocol) {
        self._chatData = chatData
        self.coordinator = coordinator
    }
    
    // MARK: - Internal Methods
    
    func onProfile(_ contact: Contact) {
        coordinator.friendProfile(contact)
    }
}
