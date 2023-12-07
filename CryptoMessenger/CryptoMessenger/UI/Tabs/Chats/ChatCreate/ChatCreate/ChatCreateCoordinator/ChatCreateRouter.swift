import Foundation
import SwiftUI

protocol ChatCreateRouterable: View {
    
    func onCountryCodeScene(_ countryCode: CountryCodePickerDelegate)

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

struct ChatCreateRouter<
    Content: View,
    State: ChatCreateFlowStateProtocol,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.createPath) {
            content()
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
    
    func onCountryCodeScene(_ countryCode: CountryCodePickerDelegate) {
        state.createPath.append(
            BaseContentLink.countryCodeScene(delegate: countryCode)
        )
    }
}
