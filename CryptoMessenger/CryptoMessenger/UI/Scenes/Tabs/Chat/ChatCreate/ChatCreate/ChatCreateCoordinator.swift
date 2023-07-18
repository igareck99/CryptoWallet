import SwiftUI

// MARK: - ChatCreateFlowCoordinatorProtocol

protocol ChatCreateFlowCoordinatorProtocol {
    func selectContact(_ chatData: Binding<ChatData>,
                       _ coordinator: ChatCreateFlowCoordinatorProtocol)
    func createContact()
    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol)
    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol)
    func toParentCoordinator()
}

// MARK: - ChatCreateFlowCoordinator

final class ChatCreateFlowCoordinator<Router: ChatCreateRouterable> {
    
    @Binding var chatData: ChatData
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let onCoordinatorEnd: (Coordinator) -> Void

    init(router: Router,
         chatData: Binding<ChatData>,
         onCoordinatorEnd: @escaping (Coordinator) -> Void) {
        self.router = router
        self._chatData = chatData
        self.onCoordinatorEnd = onCoordinatorEnd
    }
}

// MARK: - ChatCreateFlowCoordinator(Coordinator)

extension ChatCreateFlowCoordinator: Coordinator {
    func start() {
        router.createChat($chatData, self)
    }
}

// MARK: - ChatCreateFlowCoordinator(ContentFlowCoordinatorProtocol)

extension ChatCreateFlowCoordinator: ChatCreateFlowCoordinatorProtocol {

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        router.createChannel(coordinator)
    }

    func selectContact(_ chatData: Binding<ChatData>,
                       _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        router.selectContact(chatData, coordinator: coordinator)
    }

    func createContact() {
        print("tireowerieo32ieo32")
        router.createContact()
    }
    
    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        print("slkasklasklasklaskl")
        router.createGroupChat(chatData, coordinator)
    }
    
    func toParentCoordinator() {
        onCoordinatorEnd(self)
    }
}
