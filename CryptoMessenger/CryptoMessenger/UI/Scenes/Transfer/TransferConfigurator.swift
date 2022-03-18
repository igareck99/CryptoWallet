import Foundation

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: TransferSceneDelegate?) -> TransferView {
        let viewModel = TransferViewModel()
        viewModel.delegate = delegate
        let view = TransferView(viewModel: viewModel)
        return view
    }
}
