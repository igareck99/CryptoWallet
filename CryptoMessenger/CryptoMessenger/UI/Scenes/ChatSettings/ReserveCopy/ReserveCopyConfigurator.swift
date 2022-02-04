import Foundation

// MARK: - ReserveCopyConfigurator

enum ReserveCopyConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ReserveCopySceneDelegate?) -> ReserveCopyView {
        let viewModel = ReserveCopyViewModel()
        viewModel.delegate = delegate
        let view = ReserveCopyView(viewModel: viewModel)
        return view
    }
}
