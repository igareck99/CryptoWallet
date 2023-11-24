import SwiftUI

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func build(
        wallet: WalletInfo,
        coordinator: TransferViewCoordinatable,
        receiverData: UserReceiverData? = nil
    ) -> some View {
        let viewModel = TransferViewModel(
            wallet: wallet,
            coordinator: coordinator,
            receiverData: receiverData
        )
		let view = TransferView(viewModel: viewModel)
        return view
    }
}
