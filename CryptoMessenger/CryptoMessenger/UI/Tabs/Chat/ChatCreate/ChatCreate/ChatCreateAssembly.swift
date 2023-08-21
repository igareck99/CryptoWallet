import Foundation
import SwiftUI

// MARK: - ChatCreateAssembly

enum ChatCreateAssembly {
    static func build(_ coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
