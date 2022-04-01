import Foundation

// MARK: - PinCodeCreateConfigurator

enum PinCodeCreateConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PinCodeCreateSceneDelegate?,
                               screenType: PinCodeScreenType) -> PinCodeCreateView {
        let viewModel = PinCodeCreateViewModel(screenType: screenType)
        viewModel.delegate = delegate
        let view = PinCodeCreateView(viewModel: viewModel)
        return view
    }
}
