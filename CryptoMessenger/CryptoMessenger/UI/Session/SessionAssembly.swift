import SwiftUI

// MARK: - SessionAssembly

enum SessionAssembly {

    // MARK: - Static Methods

    static func build(_ coordinator: ProfileFlowCoordinatorProtocol) -> some View {
		let userSettings = UserDefaultsService.shared
        let viewModel = SessionViewModel(userSettings: userSettings)
        let view = SessionListView(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
