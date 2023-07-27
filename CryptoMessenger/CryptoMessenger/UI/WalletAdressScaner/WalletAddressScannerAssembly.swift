import SwiftUI

// MARK: - WalletAddressScannerAssembly

enum WalletAddressScannerAssembly {

    // MARK: - Static Methods

    static func build(
        scannedCode: Binding<String>
    ) -> WalletAddressScanerView {
		let userSettings = UserDefaultsService.shared
        let viewModel = WalletAddressScanerViewModel(userSettings: userSettings)
        let view = WalletAddressScanerView(scannedCode: scannedCode, viewModel: viewModel)
        return view
    }
}
