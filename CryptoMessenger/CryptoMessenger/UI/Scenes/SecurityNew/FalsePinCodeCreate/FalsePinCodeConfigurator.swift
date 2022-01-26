import Foundation

// MARK: - FalsePinCodeConfigurator

enum FalsePinCodeConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: FalsePinCodeSceneDelegate?) -> FalsePinCodeView {
        let viewModel = FalsePinCodeViewModel()
        viewModel.delegate = delegate
        let view = FalsePinCodeView(viewModel: viewModel)
        return view
    }
}
