import Foundation

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: TransferSceneDelegate?) -> TransferView {
		let userSettings = UserDefaultsService.shared
        let viewModel = TransferViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = TransferView(viewModel: viewModel)
        return view
    }
}
