import Foundation

// MARK: - ChooseReceiverConfigurator

enum ChooseReceiverConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChooseReceiverSceneDelegate?) -> ChooseReceiverView {
        let viewModel = ChooseReceiverViewModel()
        viewModel.delegate = delegate
        let view = ChooseReceiverView(viewModel: viewModel)
        return view
    }
}
