import SwiftUI

enum TransactionAssembly {
    static func build(
        selectorFilterIndex: Int,
        selectorTokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    ) -> some View {
        let viewModel = TransactionViewModel(coordinator: coordinator)
        let view = TransactionView(
			viewModel: viewModel,
			selectorFilterIndex: selectorFilterIndex,
			selectorTokenIndex: selectorTokenIndex,
			address: address,
			tappedTransaction: TransactionInfo.mock
		)
        return view
    }
}
