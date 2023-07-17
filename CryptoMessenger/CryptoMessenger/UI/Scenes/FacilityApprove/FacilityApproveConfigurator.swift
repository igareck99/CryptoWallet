import SwiftUI

// MARK: - FacilityApproveConfigurator

enum FacilityApproveConfigurator {

    // MARK: - Static Methods

    static func build(
        transaction: FacilityApproveModel,
        coordinator: WalletCoordinatable
    ) -> some View {
		let viewModel = FacilityApproveViewModel(
			transaction: transaction,
			coordinator: coordinator
		)
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
