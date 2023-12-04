import SwiftUI

enum ChatGroupAssembly {
    static func build(
        type: CreateGroupCases,
        users: [Contact] = [],
        coordinator: ChatCreateFlowCoordinatorProtocol
    ) -> some View {
        let viewModel = ChatGroupViewModel(type: type, contacts: users)
        viewModel.coordinator = coordinator
        let view = ChatGroupView(viewModel: viewModel)
        return view
    }
}
