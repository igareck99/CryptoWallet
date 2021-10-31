import Foundation

// MARK: - ChatRoomConfigurator

enum ChatRoomConfigurator {

    // MARK: - Static Methods

    static func configuredView(userMessage: Message, delegate: ChatRoomSceneDelegate?) -> ChatRoomView {
        let viewModel = ChatRoomViewModel(userMessage: userMessage)
        viewModel.delegate = delegate
        let view = ChatRoomView(viewModel: viewModel)
        return view
    }

    static func configuredView(userMessage: Message, showHistory: Bool, delegate: ChatRoomSceneDelegate?) -> ChatRoomView {
        let viewModel = ChatRoomViewModel(userMessage: userMessage, showHistory: showHistory)
        viewModel.delegate = delegate
        let view = ChatRoomView(viewModel: viewModel)
        return view
    }
}
