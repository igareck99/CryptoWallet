import Foundation
import SwiftUI

protocol ChatCreateRouterable: View {

    func selectContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )

    func createContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )

    func createChannel(
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [SelectContact]
    )

    func createGroupChat(
        chatData: ChatData,
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [Contact]
    )

    func createChat(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )
}

// MARK: - ChatCreateRouter(ChatCreateFlowStateProtocol)

struct ChatCreateRouter<Content: View, State: ChatCreateFlowStateProtocol>: View {

    @ObservedObject var state: State
    let content: () -> Content
    private let factory = ViewsBaseFactory.self

    var body: some View {
        NavigationStack(path: $state.createPath) {
            ZStack {
                content()
            }
            .navigationDestination(
                for: BaseContentLink.self,
                destination: factory.makeContent
            )
        }
    }
}

extension ChatCreateRouter: ChatCreateRouterable {

    func selectContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    ) {
        state.createPath.append(
            BaseContentLink.selectContact(
                coordinator: coordinator
            )
        )
    }

    func createChannel(
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [SelectContact]
    ) {
        state.createPath.append(
            BaseContentLink.createChannel(
                coordinator: coordinator,
                contacts: contacts
            )
        )
    }

    func createContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    ) {
        state.createPath.append(
            BaseContentLink.createContact(
                coordinator: coordinator
            )
        )
    }

    func createGroupChat(
        chatData: ChatData,
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [Contact]
    ) {
        state.createPath.append(
            BaseContentLink.createGroupChat(
                chatData: chatData,
                coordinator: coordinator,
                contacts: contacts
            )
        )
    }

    func createChat(
        coordinator: ChatCreateFlowCoordinatorProtocol
    ) {
        state.createPath.append(
            BaseContentLink.createChat(
                coordinator: coordinator
            )
        )
    }
}
