import SwiftUI

// MARK: - SelectContactAssembly

enum SelectContactAssembly {
    static func build(_ mode: ContactViewMode,
                      _ chatData: Binding<ChatData>,
                      coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = SelectContactViewModel(mode: mode)
        viewModel.coordinator = coordinator
        let view = SelectContactView(viewModel: viewModel, chatData: chatData)
        return view
    }
}
