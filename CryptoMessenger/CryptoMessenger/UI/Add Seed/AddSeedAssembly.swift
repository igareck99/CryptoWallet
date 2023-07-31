import SwiftUI

enum AddSeedAssembly {
    static func build(coordinator: AddSeedCoordinatable) -> some View {
        let viewModel = AddSeedViewModel()
        viewModel.coordinator = coordinator
        let view = AddSeedView(viewModel: viewModel)
        return view
    }
}
