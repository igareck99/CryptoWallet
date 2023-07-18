import Foundation
import SwiftUI

protocol ChatCreateRouterable {

    func selectContact(_ chatData: Binding<ChatData>,
                       coordinator: ChatCreateFlowCoordinatorProtocol)
    func createContact()

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol)

    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol)
}

struct ChatCreateRouter<Content: View, State: ChatHistoryFlowStateProtocol>: View {

    @ObservedObject var state: State

    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
            }
            .navigationDestination(for: ChatCreateContentLink.self,
                                   destination: linkDestination)
        }
    }

    @ViewBuilder
    private func linkDestination(link: ChatCreateContentLink) -> some View {
        switch link {
        case .createContact:
            CreateContactView(viewModel: CreateContactViewModel())
        case let .createChannel(coordinator):
            CreateChannelAssemby.make(coordinator: coordinator)
        case let .selectContact(chatData, coordinator):
            SelectContactAssembly.build(.groupCreate,
                                        chatData,
                                        coordinator: coordinator)
        case let .createGroupChat(chatData, coordinator):
            ChatGroupAssembly.build(chatData,
                                    coordinator: coordinator)
        }
    }
}

extension ChatCreateRouter: ChatCreateRouterable {

    func selectContact(_ chatData: Binding<ChatData>,
                       coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.path.append(ChatCreateContentLink.selectContact(chatData, coordinator))
    }

    func createChannel(_ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.path.append(ChatCreateContentLink.createChannel(coordinator))
    }

    func createContact() {
        state.path.append(ChatCreateContentLink.createContact)
    }
    
    func createGroupChat(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatCreateFlowCoordinatorProtocol) {
        state.path.append(ChatCreateContentLink.createGroupChat(chatData, coordinator))
    }
}
