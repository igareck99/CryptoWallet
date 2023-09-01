import SwiftUI

// MARK: - MembersViewModelDelegate

protocol MembersViewModelDelegate: ObservableObject {
    
    var membersViews: [any ViewGeneratable] { get }
}

// MARK: - MembersViewModel

final class MembersViewModel: ObservableObject, MembersViewModelDelegate {
    
    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    @Published var membersViews: [any ViewGeneratable] = []
    var coordinator: ChatHistoryFlowCoordinatorProtocol

    // MARK: - Lifecyle

    init(chatData: Binding<ChatData>,
         coordinator: ChatHistoryFlowCoordinatorProtocol) {
        self._chatData = chatData
        self.coordinator = coordinator
        self.configView()
    }

    // MARK: - Internal Methods

    func onProfile(_ contact: Contact) {
        coordinator.friendProfile(contact)
    }

    private func configView() {
        membersViews = chatData.contacts.map {
            let data = Contact(mxId: $0.mxId, name: $0.name, status: $0.status) { contact in
                self.onProfile(contact)
            }
            return data
        }
    }
}
