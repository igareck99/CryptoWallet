import SwiftUI

// MARK: - ChatCreateFlowCoordinatorProtocol

protocol ChatCreateFlowCoordinatorProtocol {
    func selectContact()
    func createContact()
    func createChannel()
    func createGroupChat(_ chatData: ChatData)
    func toParentCoordinator()
}

// MARK: - ChatCreateFlowCoordinator

final class ChatCreateFlowCoordinator<Router: ChatCreateRouterable> {

    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let onCoordinatorEnd: (Coordinator) -> Void

    init(router: Router,
         onCoordinatorEnd: @escaping (Coordinator) -> Void) {
        self.router = router
        self.onCoordinatorEnd = onCoordinatorEnd
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

    func createChannel() {
        router.createChannel(self)
    }

    func selectContact() {
        router.selectContact(self)
    }

    func createContact() {
        router.createContact(self)
    }
    
    func createGroupChat(_ chatData: ChatData) {
        router.createGroupChat(chatData, self)
    }
    
    func toParentCoordinator() {
        onCoordinatorEnd(self)
    }
}
