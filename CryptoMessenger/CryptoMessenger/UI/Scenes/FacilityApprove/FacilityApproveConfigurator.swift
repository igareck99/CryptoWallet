import Foundation

// MARK: - FacilityApproveConfigurator

enum FacilityApproveConfigurator {

    // MARK: - Static Methods

    static func configuredView(
		transaction: FacilityApproveModel,
		delegate: FacilityApproveSceneDelegate
	) -> FacilityApproveView {
		let userCredentialsStorage = UserDefaultsService.shared
		let viewModel = FacilityApproveViewModel(transaction: transaction)
        viewModel.delegate = delegate
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
