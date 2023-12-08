import SwiftUI

enum SessionAssembly {
    static func build(coordinator: ProfileCoordinatable) -> some View {
		let userSettings = UserDefaultsService.shared
        let viewModel = SessionViewModel(userSettings: userSettings)
        let view = SessionListView(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
