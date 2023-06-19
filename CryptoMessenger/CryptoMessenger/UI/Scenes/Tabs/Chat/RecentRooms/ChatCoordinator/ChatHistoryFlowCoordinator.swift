import SwiftUI

protocol ChatHistoryFlowCoordinatorProtocol {
    func firstAction(_ room: AuraRoom)
    func showCreateChat(_ chatData: Binding<ChatData>)
}

final class ChatHistoryFlowCoordinator {
    
   private let router: ChatHistorySceneDelegate
    
    init(router: ChatHistorySceneDelegate) {
        self.router = router
    }
}
    
// MARK: - ContentFlowCoordinatorProtocol

extension ChatHistoryFlowCoordinator: ChatHistoryFlowCoordinatorProtocol {
    
    func firstAction(_ room: AuraRoom) {
        //router.routeToFirstAction(room)
        router.handleNextScene(.chatRoom(room))
    }
    
    func showCreateChat(_ chatData: Binding<ChatData>) {
        //router.routeToCreateChat(chatData)
    }
}
