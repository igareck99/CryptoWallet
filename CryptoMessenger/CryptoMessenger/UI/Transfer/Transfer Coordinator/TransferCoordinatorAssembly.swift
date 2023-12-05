import SwiftUI

enum TransferCoordinatorAssembly {
    static func build(
        wallet: WalletInfo,
        receiverData: UserReceiverData? = nil,
        path: Binding<NavigationPath>,
        presentedItem: Binding<BaseSheetLink?>,
        onFinish: @escaping (Coordinator, TransactionResult) -> Void
    ) -> Coordinator {
        let state = TransferState(path: path, presentedItem: presentedItem)
        let router = TransferRouter(state: state)
        let coordinator = TransferCoordinator(
            wallet: wallet,
            router: router,
            receiverData: receiverData,
            onFinish: onFinish
        )
        return coordinator
    }
}
