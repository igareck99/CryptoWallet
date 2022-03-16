import Foundation

// MARK: - FacilityApproveConfigurator

enum FacilityApproveConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: FacilityApproveSceneDelegate?) -> FacilityApproveView {
        let viewModel = FacilityApproveViewModel()
        viewModel.delegate = delegate
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
