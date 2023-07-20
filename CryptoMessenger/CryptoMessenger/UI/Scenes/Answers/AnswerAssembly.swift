import SwiftUI

// MARK: - AnswerAssembly

enum AnswerAssembly {

    // MARK: - Static Methods

    static func build(_ coordinator: ProfileFlowCoordinatorProtocol) -> some View {
        let viewModel = AnswersViewModel()
        viewModel.coordinator = coordinator
        let view = AnswerView(viewModel: viewModel)
        return view
    }
}
