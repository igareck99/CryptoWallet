import Foundation
import SwiftUI

protocol ChatCreateRouterable: View {

    func selectContact(_ coordinator: ChatCreateFlowCoordinatorProtocol)
    func createContact(_ coordinator: ChatCreateFlowCoordinatorProtocol)

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol,
                       _ contacts: [SelectContact])

    func createGroupChat(_ chatData: ChatData,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol,
                         _ contacts: [Contact])
    func createChat(_ coordinator: ChatCreateFlowCoordinatorProtocol)
}

// MARK: - ChatCreateRouter(ChatCreateFlowStateProtocol)


struct ChatCreateRouter<Content: View, State: ChatCreateFlowStateProtocol>: View {

    @ObservedObject var state: State
    let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $state.createPath) {
            ZStack {
                content()
            }
            .navigationDestination(
                for: ChatCreateSheetContentLink.self,
                destination: linkDestinationCreate
            )
        }
    }

    @ViewBuilder
    private func linkDestinationCreate(link: ChatCreateSheetContentLink) -> some View {
        switch link {
        case let .createChat(coordinator):
            ChatCreateAssembly.build(coordinator)
        case let .createContact(coordinator):
            CreateContactsAssembly.build(coordinator)
        case let .createChannel(coordinator, contacts):
            ChatGroupAssembly.build(type: .channel, coordinator: coordinator)
        case let .selectContact(coordinator):
            GroupChatSelectContactAssembly.build(coordinator: coordinator)
        case let .createGroupChat(chatData, coordinator, contacts):
            ChatGroupAssembly.build(type: .groupChat, users: contacts, coordinator: coordinator)
        }
    }
}

extension ChatCreateRouter: ChatCreateRouterable {

    func selectContact(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.selectContact(coordinator))
    }

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol,
                       _ contacts: [SelectContact]) {
        state.createPath.append(ChatCreateSheetContentLink.createChannel(coordinator, contacts))
    }

    func createContact(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createContact(coordinator))
    }

    func createGroupChat(_ chatData: ChatData,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol,
                         _ contacts: [Contact]) {
        state.createPath.append(ChatCreateSheetContentLink.createGroupChat(chatData, coordinator, contacts))
    }
    
    func createChat(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createChat(coordinator: coordinator))
    }
}
