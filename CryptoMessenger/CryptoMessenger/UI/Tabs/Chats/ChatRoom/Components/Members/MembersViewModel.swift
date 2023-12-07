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
    var coordinator: ChatsCoordinatable
    let resources: MembersResourcable.Type

    // MARK: - Lifecyle

    init(chatData: Binding<ChatData>,
         coordinator: ChatsCoordinatable,
         resources: MembersResourcable.Type = MembersResources.self
    ) {
        self.resources = resources
        self._chatData = chatData
        self.coordinator = coordinator
        self.configView()
    }

    // MARK: - Internal Methods

    func onProfile(_ contact: Contact) {
        // coordinator.friendProfile(contact)
    }

    private func configView() {
        membersViews = chatData.contacts.map {
            let data = Contact(mxId: $0.mxId, name: $0.name, status: $0.status, phone: "") { contact in
                self.onProfile(contact)
            }
            return data
        }
    }
}
