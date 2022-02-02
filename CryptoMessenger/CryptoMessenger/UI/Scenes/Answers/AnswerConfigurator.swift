import Foundation

// MARK: - AnswerConfigurator

enum AnswerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: AnswersSceneDelegate?) -> AnswerView {
        let viewModel = AnswersViewModel()
        viewModel.delegate = delegate
        let view = AnswerView(viewModel: viewModel)
        return view
    }
}
