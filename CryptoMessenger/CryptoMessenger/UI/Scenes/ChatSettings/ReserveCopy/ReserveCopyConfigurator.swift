import Foundation

// MARK: - ReserveCopyConfigurator

enum ReserveCopyConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ReserveCopySceneDelegate?) -> ReserveCopyView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = ReserveCopyViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = ReserveCopyView(viewModel: viewModel)
        return view
    }
}
