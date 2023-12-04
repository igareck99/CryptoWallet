import SwiftUI

enum WalletAddressScannerAssembly {
    static func build(
        scannedCode: Binding<String>
    ) -> WalletAddressScanerView {
		let userSettings = UserDefaultsService.shared
        let viewModel = WalletAddressScanerViewModel(userSettings: userSettings)
        let view = WalletAddressScanerView(scannedCode: scannedCode, viewModel: viewModel)
        return view
    }
}
