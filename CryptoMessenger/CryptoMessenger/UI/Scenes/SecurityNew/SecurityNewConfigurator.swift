import Foundation

// MARK: - SecurityConfigurator

enum SecurityConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SecuritySceneDelegate?,
                               togglesFacade: MainFlowTogglesFacadeProtocol) -> SecurityView {
		let userSettings = UserDefaultsService.shared
        let viewModel = SecurityViewModel(userSettings: userSettings, togglesFacade: togglesFacade)
        viewModel.delegate = delegate
        let view = SecurityView(viewModel: viewModel)
        return view
    }
}
