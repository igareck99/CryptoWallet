import Foundation

// MARK: - TransactionConfigurator

enum TransactionConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: TransactionSceneDelegate?,
                               selectorFilterIndex: Int,
                               selectorTokenIndex: Int,
                               address: String) -> TransactionView {
        let viewModel = TransactionViewModel()
        viewModel.delegate = delegate
        let view = TransactionView(viewModel: viewModel,
                                   selectorFilterIndex: selectorFilterIndex,
                                   selectorTokenIndex: selectorTokenIndex,
                                   address: address)
        return view
    }
}
