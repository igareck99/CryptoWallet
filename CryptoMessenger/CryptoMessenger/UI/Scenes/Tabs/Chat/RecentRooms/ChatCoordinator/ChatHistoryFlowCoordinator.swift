import SwiftUI

// MARK: - ChatHistoryFlowCoordinatorProtocol

protocol ChatHistoryFlowCoordinatorProtocol {
    func firstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)
    func showCreateChat(_ chatData: Binding<ChatData>)
    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol)
    func chatMedia(_ room: AuraRoom)
    func friendProfile(_ contact: Contact)
    func adminsView( _ chatData: Binding<ChatData>,
                     _ coordinator: ChatHistoryFlowCoordinatorProtocol)
}

protocol ChatHistoryFlowCoordinatorProtocoll {
    func firstAction(_ room: AuraRoom)
    func showCreateChat(_ chatData: Binding<ChatData>)
}

final class ChatHistoryFlowCoordinator {
    private let router: ChatHistoryRouterable
    private let state: ChatHistoryFlowState
    
    init(
        router: ChatHistoryRouterable,
        state: ChatHistoryFlowState
    ) {
        self.router = router
        self.state = state
    }
}

// MARK: - ContentFlowCoordinatorProtocol

extension ChatHistoryFlowCoordinator: ChatHistoryFlowCoordinatorProtocol {

    func firstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol) {
        router.routeToFirstAction(room, coordinator: coordinator)
    }

    func start() {
        router.start()
    }

    func chatMedia(_ room: AuraRoom) {
        router.chatMedia(room)
    }

    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) {
        if isChannel {
            router.channelSettings(chatData: chatData,
                                   saveData: saveData,
                                   room: room,
                                   isLeaveChannel: isLeaveChannel,
                                   coordinator: coordinator)
        } else {
            router.chatSettings(chatData: chatData,
                                saveData: saveData,
                                room: room,
                                isLeaveChannel: isLeaveChannel,
                                coordinator: coordinator)
        }
    }

    func friendProfile(_ contact: Contact) {
        router.friendProfile(contact)
    }

    func adminsView(
        _ chatData: Binding<ChatData>,
        _ coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        router.adminsView(chatData, coordinator)
    }

    func showCreateChat(_ chatData: Binding<ChatData>) {
        router.routeToCreateChat(chatData)
    }
}
