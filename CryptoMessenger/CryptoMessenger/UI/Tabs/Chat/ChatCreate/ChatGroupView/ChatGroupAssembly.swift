import SwiftUI

// MARK: - ChatGroupAssembly

enum ChatGroupAssembly {
    static func build(type: CreateGroupCases,
                      coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        var viewModel = ChatGroupViewModel(type: type)
        viewModel.coordinator = coordinator
        let view = ChatGroupView(viewModel: viewModel)
        return view
    }
}

