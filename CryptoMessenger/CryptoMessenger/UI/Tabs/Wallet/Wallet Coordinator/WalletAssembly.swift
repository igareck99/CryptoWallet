import Foundation
import SwiftUI

typealias WalletCoordinatorType = WalletCoordinator<WalletRouter<WalletView<WalletViewModel>,WalletRouterState,ViewsBaseFactory>>

enum WalletAssembly {

    static weak var coordinator: WalletCoordinatorType?

    static func build() -> some View {
        let viewModel = WalletViewModel()
        let view = WalletView(viewModel: viewModel)
        let router = WalletRouter(
            state: WalletRouterState.shared,
            factory: ViewsBaseFactory.self
        ) {
            view
        }
        let coordinator = WalletCoordinator(router: router)
        viewModel.coordinator = coordinator
        Self.coordinator = coordinator
        return router
    }
}
