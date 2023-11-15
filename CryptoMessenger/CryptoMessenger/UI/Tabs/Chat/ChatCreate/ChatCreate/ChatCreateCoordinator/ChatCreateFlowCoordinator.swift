import SwiftUI

// MARK: - ChatCreateFlowCoordinatorProtocol

protocol ChatCreateFlowCoordinatorProtocol {
    func selectContact()
    func createContact()
    func createChannel(_ contacts: [SelectContact])
    func createGroupChat(_ chatData: ChatData, _ contacts: [Contact])
    func toParentCoordinator()
    func onFriendProfile(_ room: AuraRoomData)
}

// MARK: - ChatCreateFlowCoordinator

final class ChatCreateFlowCoordinator<Router: ChatCreateRouterable> {

    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let onCoordinatorEnd: (Coordinator) -> Void
    private let onFriendProfile: (AuraRoomData) -> Void

    init(router: Router,
         onCoordinatorEnd: @escaping (Coordinator) -> Void,
         onFriendProfile: @escaping (AuraRoomData) -> Void) {
        self.router = router
        self.onCoordinatorEnd = onCoordinatorEnd
        self.onFriendProfile = onFriendProfile
    }
}

// MARK: - ChatCreateFlowCoordinator(Coordinator)

extension ChatCreateFlowCoordinator: Coordinator {
    func start() {
        router.createChat(self)
    }
    func startWithView(completion: @escaping RootViewBuilder) {
        completion(router)
    }
}

// MARK: - ChatCreateFlowCoordinator(ContentFlowCoordinatorProtocol)

extension ChatCreateFlowCoordinator: ChatCreateFlowCoordinatorProtocol {

    func createChannel(_ contacts: [SelectContact]) {
        router.createChannel(self, contacts)
    }

    func selectContact() {
        router.selectContact(self)
    }

    func createContact() {
        router.createContact(self)
    }
    
    func createGroupChat(_ chatData: ChatData, _ contacts: [Contact]) {
        router.createGroupChat(chatData, self, contacts)
    }
    
    func onFriendProfile(_ room: AuraRoomData) {
        onFriendProfile(room)
    }
    
    func toParentCoordinator() {
        onCoordinatorEnd(self)
    }
}
