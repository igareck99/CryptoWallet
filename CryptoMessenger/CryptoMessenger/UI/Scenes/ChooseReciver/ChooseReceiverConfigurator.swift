import Foundation

// MARK: - ChooseReceiverConfigurator

enum ChooseReceiverConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChooseReceiverSceneDelegate?) -> ChooseReceiverView {
		let userSettings = UserDefaultsService.shared
        let viewModel = ChooseReceiverViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ChooseReceiverView(viewModel: viewModel)
        return view
    }
}
