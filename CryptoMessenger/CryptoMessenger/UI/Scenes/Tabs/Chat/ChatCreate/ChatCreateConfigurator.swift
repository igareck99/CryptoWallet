import Foundation

// MARK: - ChatCreateConfigurator

enum ChatCreateConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatCreateSceneDelegate?) -> ChatCreateView {
        let viewModel = ChatCreateViewModel()
        viewModel.delegate = delegate
        let view = ChatCreateView(viewModel: viewModel)
        return view
    }
}
