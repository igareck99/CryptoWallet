import Foundation
import SwiftUI

enum RegistrationConfigurator {

    static func build(delegate: RegistrationSceneDelegate?) -> some View {
        let viewModel = RegistrationPresenter(
            userCredentials: UserDefaultsService.shared,
            keychainService: KeychainService.shared,
            colors: RegistrationColors()
        )
        viewModel.delegate = delegate
        let view = PhoneRegistrationView(viewModel: viewModel)
        return view
    }
}
