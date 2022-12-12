import Foundation

// MARK: - ChatMediaConfigurator

enum ChatMediaConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        room: AuraRoom,
        delegate: ChatMediaSceneDelegate
    ) -> ChatMediaView {
        let viewModel = ChatMediaViewModel(room: room)
        viewModel.delegate = delegate
        return ChatMediaView(viewModel: viewModel)
    }
}
