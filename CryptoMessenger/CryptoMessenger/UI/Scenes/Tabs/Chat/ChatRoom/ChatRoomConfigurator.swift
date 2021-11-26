import Foundation

// MARK: - ChatRoomConfigurator

enum ChatRoomConfigurator {

    // MARK: - Static Methods

    static func configuredView(room: AuraRoom, delegate: ChatRoomSceneDelegate?) -> ChatRoomView {
        let viewModel = ChatRoomViewModel(room: room)
        viewModel.delegate = delegate
        let view = ChatRoomView(viewModel: viewModel)
        return view
    }
}
