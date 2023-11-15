import SwiftUI

// MARK: - AdminsViewModelDelegate

protocol AdminsViewModelDelegate: ObservableObject {
    
    var membersViews: [any ViewGeneratable] { get }
    var resources: AdminsResourcable.Type { get }
}

// MARK: - AdminsViewModel

final class AdminsViewModel: ObservableObject, AdminsViewModelDelegate {
    
    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    @Published var membersViews: [any ViewGeneratable] = []
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    let resources: AdminsResourcable.Type

    // MARK: - Lifecyle

    init(chatData: Binding<ChatData>,
         coordinator: ChatHistoryFlowCoordinatorProtocol,
         resources: AdminsResourcable.Type = AdminsResources.self
    ) {
        self.resources = resources
        self._chatData = chatData
        self.coordinator = coordinator
        self.configView()
    }

    // MARK: - Internal Methods

    func onProfile(_ contact: Contact) {
        coordinator.friendProfile(contact)
    }

    // MARK: - Private Methods

    private func configView() {
        membersViews = chatData.contacts.filter({ $0.isAdmin == true }).map {
            let data = Contact(mxId: $0.mxId, name: $0.name, status: $0.status, phone: "") { contact in
                self.onProfile(contact)
            }
            return data
        }
    }
}
