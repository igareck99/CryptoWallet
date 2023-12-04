import SwiftUI

enum AnswerAssembly {
    static func build(coordinator: ProfileFlowCoordinatorProtocol) -> some View {
        let viewModel = AnswersViewModel()
        viewModel.coordinator = coordinator
        let view = AnswerView(viewModel: viewModel)
        return view
    }
}
