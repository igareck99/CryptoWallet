import SwiftUI

// MARK: - SecurityAssembly

enum SecurityAssembly {

    // MARK: - Static Methods

    static func configuredView(_ coordinator: ProfileFlowCoordinatorProtocol) -> some View {
		let userSettings = UserDefaultsService.shared
        let togglesFacade = MainFlowTogglesFacade.shared
        let viewModel = SecurityViewModel(userSettings: userSettings, togglesFacade: togglesFacade)
        viewModel.coordinator = coordinator
        let view = SecurityView(viewModel: viewModel)
        return view
    }
}
