import Foundation
import SwiftUI

enum ChatCreateAssembly {
    static func build(coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return view
    }
}
