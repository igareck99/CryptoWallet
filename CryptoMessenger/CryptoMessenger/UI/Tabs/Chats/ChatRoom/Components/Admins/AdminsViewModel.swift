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
    var coordinator: ChatsCoordinatable
    let resources: AdminsResourcable.Type

    // MARK: - Lifecyle

    init(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable,
        resources: AdminsResourcable.Type = AdminsResources.self
    ) {
        self.resources = resources
        self._chatData = chatData
        self.coordinator = coordinator
        self.configView()
    }

    // MARK: - Internal Methods

    func onProfile(
        userId: String,
        roomId: String
    ) {
        coordinator.friendProfile(
            userId: userId,
            roomId: roomId
        )
    }

    // MARK: - Private Methods

    private func configView() {
        membersViews = chatData.contacts.filter({ $0.isAdmin == true }).map {
            let data = Contact(mxId: $0.mxId, name: $0.name, status: $0.status, phone: "") { _ in
//                self.onProfile(chatData.,data.mxId)
            }
            return data
        }
    }
}
