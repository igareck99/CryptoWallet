import SwiftUI

// MARK: - PinCodeAssembly

enum PinCodeAssembly {

    // MARK: - Static Methods

    static func build(delegate: PinCodeSceneDelegate?,
                      screenType: PinCodeScreenType) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let biometryService = BiometryService()
        let sources = PinCodeSources.self
        let viewModel = PinCodeViewModel(delegate: delegate,
                                            screenType: screenType,
                                            userSettings: userSettings,
                                            keychainService: keychainService,
                                            biometryService: biometryService,
                                            sources: sources)
        let view = PinCodeView(viewModel: viewModel)
        return view
    }
}
