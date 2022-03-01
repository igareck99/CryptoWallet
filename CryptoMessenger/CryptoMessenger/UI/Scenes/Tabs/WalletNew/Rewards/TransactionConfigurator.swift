import Foundation

// MARK: - TransactionConfigurator

enum TransactionConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: TransactionSceneDelegate?) -> TransactionView {
        let viewModel = TransactionViewModel()
        viewModel.delegate = delegate
        let view = TransactionView(viewModel: viewModel)
        return view
    }
}
