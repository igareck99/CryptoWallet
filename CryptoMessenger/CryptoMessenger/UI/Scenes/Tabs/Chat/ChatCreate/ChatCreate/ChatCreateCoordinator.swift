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

final class ChatCreateFlowCoordinator {

    private let router: ChatCreateRouterable
    var onCoordinatorEnd: VoidBlock

    init(router: ChatCreateRouterable,
         onCoordinatorEnd: @escaping VoidBlock) {
        self.router = router
        self.onCoordinatorEnd = onCoordinatorEnd
    }
}

// MARK: - ContentFlowCoordinatorProtocol

extension ChatCreateFlowCoordinator: ChatCreateFlowCoordinatorProtocol {

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        router.createChannel(coordinator)
    }

    func selectContact(_ chatData: Binding<ChatData>,
                       _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        router.selectContact(chatData, coordinator: coordinator)
    }

    func createContact() {
        router.createContact()
    }
    
    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        router.createGroupChat(chatData, coordinator)
    }
    
    func toParentCoordinator() {
        onCoordinatorEnd()
    }
}
