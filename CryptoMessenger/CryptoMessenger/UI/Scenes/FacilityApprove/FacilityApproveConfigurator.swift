import Foundation

// MARK: - FacilityApproveConfigurator

enum FacilityApproveConfigurator {

    // MARK: - Static Methods

    static func configuredView(
		transaction: FacilityApproveModel,
		delegate: FacilityApproveSceneDelegate,
		onTransactionEnd: @escaping (TransactionResult) -> Void
	) -> FacilityApproveView {
		let viewModel = FacilityApproveViewModel(
			transaction: transaction,
			onTransactionEnd: onTransactionEnd
		)
        viewModel.delegate = delegate
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
