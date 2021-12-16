import Foundation

// MARK: - ChatHistoryConfigurator

enum ChatHistoryConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatHistorySceneDelegate?) -> ChatHistoryView {
        let viewModel = ChatHistoryViewModel()
        viewModel.delegate = delegate
        return ChatHistoryView(viewModel: viewModel)
    }
}
