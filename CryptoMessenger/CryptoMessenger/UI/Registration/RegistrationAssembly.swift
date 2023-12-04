import Foundation
import SwiftUI

enum RegistrationAssembly {

    static func build(delegate: RegistrationSceneDelegate?) -> some View {
        let viewModel = RegistrationPresenter(
            apiClient: APIClient.shared,
            userCredentials: UserDefaultsService.shared,
            keychainService: KeychainService.shared,
            colors: RegistrationColors()
        )
        viewModel.delegate = delegate
        let view = PhoneRegistrationView(viewModel: viewModel)
        return view
    }
}
