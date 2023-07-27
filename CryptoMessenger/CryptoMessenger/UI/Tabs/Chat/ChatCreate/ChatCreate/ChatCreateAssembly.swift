import Foundation
import SwiftUI

// MARK: - ChatCreateAssembly

enum ChatCreateAssembly {
    static func build(_ chatData: Binding<ChatData>,
                      _ coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(chatData: chatData,
                                  viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
