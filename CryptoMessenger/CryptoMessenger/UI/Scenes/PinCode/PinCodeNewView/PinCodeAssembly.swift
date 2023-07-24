import SwiftUI

// MARK: - PinCodeAssembly

enum PinCodeAssembly {

    // MARK: - Static Methods

    static func build(screenType: PinCodeScreenType,
                      onLogin: @escaping () -> Void) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let biometryService = BiometryService()
        let sources = PinCodeSources.self
        let viewModel = PinCodeViewModel(screenType: screenType,
                                            userSettings: userSettings,
                                            keychainService: keychainService,
                                            biometryService: biometryService,
                                            sources: sources,
                                            onLogin: onLogin)
        let view = PinCodeView(viewModel: viewModel)
        return view
    }
}
