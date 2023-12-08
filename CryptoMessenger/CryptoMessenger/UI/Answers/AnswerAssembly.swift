import SwiftUI

enum AnswerAssembly {
    static func build(coordinator: ProfileCoordinatable) -> some View {
        let viewModel = AnswersViewModel()
        viewModel.coordinator = coordinator
        let view = AnswerView(viewModel: viewModel)
        return view
    }
}
