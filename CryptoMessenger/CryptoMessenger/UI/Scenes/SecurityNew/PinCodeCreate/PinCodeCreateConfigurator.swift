import Foundation

// MARK: - PinCodeCreateConfigurator

enum PinCodeCreateConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PinCodeCreateSceneDelegate?,
                               screenType: PinCodeScreenType) -> PinCodeCreateView {
        let viewModel = PinCodeCreateViewModel()
        viewModel.delegate = delegate
        let view = PinCodeCreateView(viewModel: viewModel, screenType: screenType)
        return view
    }
}
