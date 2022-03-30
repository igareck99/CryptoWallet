import Foundation

// MARK: - PhraseManagerConfigurator

enum PhraseManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PhraseManagerSceneDelegate?) -> PhraseManagerView {
        let viewModel = PhraseManagerViewModel()
        viewModel.delegate = delegate
        let view = PhraseManagerView(viewModel: viewModel)
        return view
    }
}
