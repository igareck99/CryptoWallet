import Foundation

// MARK: - ReserveCopyConfigurator

enum ReservePhraseCopyConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ReservePhraseCopySceneDelegate?) -> ReserveCopyPhraseView {
        let viewModel = ReservePhraseCopyViewModel()
        viewModel.delegate = delegate
        let view = ReserveCopyPhraseView(viewModel: viewModel)
        return view
    }
}
