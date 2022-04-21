import SwiftUI

// MARK: - WalletAddressScannerConfigurator

enum WalletAddressScannerConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        delegate: WalletAddressScanerSceneDelegate?,
        scannedCode: Binding<String>
    ) -> WalletAddressScanerView {
		let userSettings = UserDefaultsService.shared
        let viewModel = WalletAddressScanerViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = WalletAddressScanerView(scannedCode: scannedCode)
        return view
    }
}
