import Foundation
import SwiftUI

protocol ChatCreateRouterable: View {

    func selectContact(_ coordinator: ChatCreateFlowCoordinatorProtocol)
    func createContact(_ coordinator: ChatCreateFlowCoordinatorProtocol)

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol)

    func createGroupChat(_ chatData: ChatData,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol)
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
        case let .createChannel(coordinator):
            CreateChannelAssemby.make(coordinator: coordinator)
        case let .selectContact(coordinator):
                SelectContactAssembly.build(
                    mode: .groupCreate,
                    coordinator: coordinator, onUsersSelected: { _ in
                    }
                )
        case let .createGroupChat(chatData, coordinator):
            ChatGroupAssembly.build(chatData,
                                    coordinator: coordinator)
        }
    }
}

extension ChatCreateRouter: ChatCreateRouterable {

    func selectContact(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.selectContact(coordinator))
    }

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createChannel(coordinator))
    }

    func createContact(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createContact(coordinator))
    }

    func createGroupChat(_ chatData: ChatData,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createGroupChat(chatData, coordinator))
    }
    
    func createChat(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.createPath.append(ChatCreateSheetContentLink.createChat(coordinator: coordinator))
    }
}
