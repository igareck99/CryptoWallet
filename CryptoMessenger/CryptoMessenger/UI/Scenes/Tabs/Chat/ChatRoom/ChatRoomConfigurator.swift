import Foundation

// MARK: - ChatRoomConfigurator

enum ChatRoomConfigurator {

    // MARK: - Static Methods

    static func configuredView(room: AuraRoom, delegate: ChatRoomSceneDelegate?, toggleFacade: MainFlowTogglesFacadeProtocol) -> ChatRoomView {
        let viewModel = ChatRoomViewModel(room: room, toggleFacade: toggleFacade)
        viewModel.delegate = delegate
        return ChatRoomView(viewModel: viewModel)
    }
}
