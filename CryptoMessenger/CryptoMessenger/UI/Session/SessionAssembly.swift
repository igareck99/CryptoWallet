import SwiftUI

enum SessionAssembly {
    static func build(coordinator: ProfileFlowCoordinatorProtocol) -> some View {
		let userSettings = UserDefaultsService.shared
        let viewModel = SessionViewModel(userSettings: userSettings)
        let view = SessionListView(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
