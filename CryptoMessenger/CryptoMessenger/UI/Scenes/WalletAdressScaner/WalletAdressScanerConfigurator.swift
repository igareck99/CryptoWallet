import SwiftUI

// MARK: - WalletAddressScanerConfigurator

enum WalletAddressScanerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletAddressScanerSceneDelegate?,
                               scannedCode: Binding<String>) -> WalletAddressScanerView {
        let viewModel = WalletAddressScanerViewModel()
        viewModel.delegate = delegate
        let view = WalletAddressScanerView(scannedCode: scannedCode)
        return view
    }
}
