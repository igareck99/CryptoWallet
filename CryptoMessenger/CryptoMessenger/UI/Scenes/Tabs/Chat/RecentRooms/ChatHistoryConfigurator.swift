import Foundation

// MARK: - ChatHistoryConfigurator

enum ChatHistoryConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatHistorySceneDelegate?) -> ChatHistoryView {
        let viewModel = ChatHistoryViewModel()
        viewModel.delegate = delegate
        var view = ChatHistoryView(viewModel: viewModel)
        view.onRoomTap = { delegate?.handleRoomTap($0) }
        return view
    }
}
