import SwiftUI

// MARK: - WalletAddressScannerConfigurator

enum WalletAddressScannerConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        delegate: WalletAddressScanerSceneDelegate?,
        scannedCode: Binding<String>
    ) -> WalletAddressScanerView {
        let viewModel = WalletAddressScanerViewModel()
        viewModel.delegate = delegate
        let view = WalletAddressScanerView(scannedCode: scannedCode)
        return view
    }
}
