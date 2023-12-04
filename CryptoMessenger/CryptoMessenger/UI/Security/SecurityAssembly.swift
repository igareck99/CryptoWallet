import SwiftUI

enum SecurityAssembly {
    static func configuredView(coordinator: ProfileFlowCoordinatorProtocol) -> some View {
		let userSettings = UserDefaultsService.shared
        let togglesFacade = MainFlowTogglesFacade.shared
        let viewModel = SecurityViewModel(userSettings: userSettings, togglesFacade: togglesFacade)
        viewModel.coordinator = coordinator
        let view = SecurityView(viewModel: viewModel)
        return view
    }
}
