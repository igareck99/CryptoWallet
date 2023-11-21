import SwiftUI

// MARK: - ChatCreateFlowCoordinatorProtocol

protocol ChatCreateFlowCoordinatorProtocol {
    func selectContact()
    func createContact()
    func createChannel(
        contacts: [SelectContact]
    )
    func createGroupChat(
        chatData: ChatData,
        contacts: [Contact]
    )
    func toParentCoordinator()
    func onFriendProfile(
        room: AuraRoomData
    )
}

// MARK: - ChatCreateFlowCoordinator

final class ChatCreateFlowCoordinator<Router: ChatCreateRouterable> {

    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let onCoordinatorEnd: (Coordinator) -> Void
    private let onFriendProfile: (AuraRoomData) -> Void

    init(
        router: Router,
        onCoordinatorEnd: @escaping (Coordinator) -> Void,
        onFriendProfile: @escaping (AuraRoomData) -> Void
    ) {
        self.router = router
        self.onCoordinatorEnd = onCoordinatorEnd
        self.onFriendProfile = onFriendProfile
    }
}

// MARK: - ChatCreateFlowCoordinator(Coordinator)

extension ChatCreateFlowCoordinator: Coordinator {
    func start() {
        router.createChat(coordinator: self)
    }

    func startWithView(completion: @escaping RootViewBuilder) {
        completion(router)
    }
}

// MARK: - ChatCreateFlowCoordinator(ContentFlowCoordinatorProtocol)

extension ChatCreateFlowCoordinator: ChatCreateFlowCoordinatorProtocol {

    func createChannel(contacts: [SelectContact]) {
        router.createChannel(
            coordinator: self,
            contacts: contacts
        )
    }

    func selectContact() {
        router.selectContact(coordinator: self)
    }

    func createContact() {
        router.createContact(coordinator: self)
    }

    func createGroupChat(
        chatData: ChatData,
        contacts: [Contact]
    ) {
        router.createGroupChat(
            chatData: chatData,
            coordinator: self,
            contacts: contacts
        )
    }

    func onFriendProfile(room: AuraRoomData) {
        onFriendProfile(room)
    }

    func toParentCoordinator() {
        onCoordinatorEnd(self)
    }
}
