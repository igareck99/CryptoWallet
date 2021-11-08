import Foundation

// MARK: - ChatHistoryConfigurator

enum ChatHistoryConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatHistorySceneDelegate?) -> ChatHistoryView {
        let viewModel = ChatHistoryViewModel()
        viewModel.delegate = delegate
        let view = ChatHistoryView(viewModel: viewModel)
        return view
    }
}
