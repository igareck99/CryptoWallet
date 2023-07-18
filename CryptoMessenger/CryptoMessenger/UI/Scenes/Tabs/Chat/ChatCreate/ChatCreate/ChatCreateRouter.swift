import Foundation
import SwiftUI

protocol ChatCreateRouterable: ObservableObject {

    func selectContact(_ chatData: Binding<ChatData>,
                       coordinator: ChatCreateFlowCoordinatorProtocol)
    func createContact()

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol)

    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol)
    func createChat(_ chatData: Binding<ChatData>,
                    _ coordinator: ChatCreateFlowCoordinatorProtocol)
}

// MARK: - ChatCreateRouter(ChatCreateFlowStateProtocol)


final class ChatCreateRouter<State: ChatCreateFlowStateProtocol> {

    var state: State
    
    init(state: State) {
        self.state = state
    }
}

extension ChatCreateRouter: ChatCreateRouterable {

    func selectContact(_ chatData: Binding<ChatData>,
                       coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.presentedItem = ChatHistorySheetLink.selectContact(chatData, coordinator)
    }

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.presentedItem = ChatHistorySheetLink.createChannel(coordinator)
    }

    func createContact() {
        state.presentedItem = ChatHistorySheetLink.createContact
    }
    
    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.presentedItem = ChatHistorySheetLink.createGroupChat(chatData, coordinator)
    }
    
    func createChat(_ chatData: Binding<ChatData>,
                    _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.presentedItem = ChatHistorySheetLink.createChat(chatData: chatData,
                                                              coordinator: coordinator)
    }
}
