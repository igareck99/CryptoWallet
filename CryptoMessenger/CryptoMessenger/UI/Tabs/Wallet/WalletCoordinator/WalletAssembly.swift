import Foundation
import SwiftUI

enum WalletAssembly {
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
        return router
    }
}
