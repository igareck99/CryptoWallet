import Foundation

// MARK: - FacilityApproveConfigurator

enum FacilityApproveConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: FacilityApproveSceneDelegate?) -> FacilityApproveView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = FacilityApproveViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
