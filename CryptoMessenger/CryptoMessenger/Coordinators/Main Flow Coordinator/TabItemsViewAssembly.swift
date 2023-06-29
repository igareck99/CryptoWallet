import SwiftUI

enum TabItemsViewAssembly {
    static func build(
        chateDelegate: ChatHistorySceneDelegate,
        profileDelegate: ProfileSceneDelegate,
        walletDelegate: WalletSceneDelegate,
        onTransactionEndHelper: @escaping TransactionEndHandler
    ) -> some View {
        let viewModel = TabItemsViewModel(
            chateDelegate: chateDelegate,
            profileDelegate: profileDelegate,
            walletDelegate: walletDelegate,
            toggles: MainFlowTogglesFacade.shared,
            factory: TabItemsFactory.self,
            onTransactionEndHelper: onTransactionEndHelper
        )
        let view = TabItemsView(viewModel: viewModel)
        return view
    }
}
