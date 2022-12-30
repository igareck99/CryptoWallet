import Foundation

// MARK: - GeneratePhraseConfigurator

enum GeneratePhraseConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: GeneratePhraseSceneDelegate?) -> GeneratePhraseView {
        let viewModel = GeneratePhraseViewModel()
        viewModel.delegate = delegate
        return GeneratePhraseView(viewModel: viewModel)
    }
}
