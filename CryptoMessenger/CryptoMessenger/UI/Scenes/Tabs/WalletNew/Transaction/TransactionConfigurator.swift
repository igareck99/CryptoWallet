import Foundation

// MARK: - TransactionConfigurator

enum TransactionConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: TransactionSceneDelegate?,
                               selectorFilterIndex: Int,
                               selectorTokenIndex: Int,
                               address: String) -> TransactionView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = TransactionViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = TransactionView(
			viewModel: viewModel,
			selectorFilterIndex: selectorFilterIndex,
			selectorTokenIndex: selectorTokenIndex,
			address: address,
			tappedTransaction: TransactionInfo.mock
		)
        return view
    }
}
