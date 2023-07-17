import Foundation
import SwiftUI

// MARK: - WalletAssembly

enum WalletAssembly {
    static func build() -> some View {
        let viewModel = WalletViewModel()
        let view = WalletView(viewModel: viewModel)
        let router = WalletRouter(state: WalletRouterState.shared) {
            view
        }
        let coordinator = WalletCoordinator(router: router)
        viewModel.coordinator = coordinator
        return router
    }
}
