import SwiftUI

// MARK: - ChatGroupAssembly

enum ChatGroupAssembly {
    static func build(_ chatData: ChatData,
                      coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        var viewModel = ChatGroupViewModel(chatData: chatData)
        viewModel.coordinator = coordinator
        let view = ChatGroupView(viewModel: viewModel)
        return view
    }
}

