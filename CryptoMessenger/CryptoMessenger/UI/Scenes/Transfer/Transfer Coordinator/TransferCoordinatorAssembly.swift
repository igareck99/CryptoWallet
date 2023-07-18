import SwiftUI

enum TransferCoordinatorAssembly {
    static func buld(
        wallet: WalletInfo,
        path: Binding<NavigationPath>,
        presentedItem: Binding<WalletSheetLink?>,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let state = TransferState(path: path, presentedItem: presentedItem)
        let router = TransferRouter(state: state)
        let coordinator = TransferCoordinator(
            wallet: wallet,
            router: router,
            onFinish: onFinish
        )
        return coordinator
    }
}
