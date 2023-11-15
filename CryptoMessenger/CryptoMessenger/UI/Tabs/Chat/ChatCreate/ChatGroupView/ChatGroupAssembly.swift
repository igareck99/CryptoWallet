import SwiftUI

// MARK: - ChatGroupAssembly

enum ChatGroupAssembly {
    static func build(type: CreateGroupCases,
                      users: [Contact] = [],
                      coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        var viewModel = ChatGroupViewModel(type: type, contacts: users)
        viewModel.coordinator = coordinator
        let view = ChatGroupView(viewModel: viewModel)
        return view
    }
}

