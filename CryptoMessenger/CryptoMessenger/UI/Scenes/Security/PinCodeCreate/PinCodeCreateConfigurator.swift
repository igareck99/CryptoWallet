import Foundation

// MARK: - PinCodeCreateConfigurator

enum PinCodeCreateConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PinCodeCreateSceneDelegate?,
                               screenType: PinCodeScreenType) -> PinCodeCreateView {
		let userSettings = UserDefaultsService.shared
		let keychainService = KeychainService.shared
        let viewModel = PinCodeCreateViewModel(
			screenType: screenType,
			userSettings: userSettings,
			keychainService: keychainService
		)
        viewModel.delegate = delegate
        let view = PinCodeCreateView(viewModel: viewModel)
        return view
    }
}
