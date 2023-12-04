import SwiftUI

enum FacilityApproveAssembly {
    static func build(
        transaction: FacilityApproveModel,
        coordinator: FacilityApproveViewCoordinatable
    ) -> some View {
		let viewModel = FacilityApproveViewModel(
			transaction: transaction,
			coordinator: coordinator
		)
        let view = FacilityApproveView(viewModel: viewModel)
        return view
    }
}
