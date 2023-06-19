import Foundation
import SwiftUI

// MARK: - WalletAssembly

enum WalletAssembly {
    static func build(_ delegate: WalletSceneDelegate,
                      onTransactionEndHelper: @escaping ( @escaping (TransactionResult) -> Void) -> Void) -> some View {
        let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = WalletViewModel(
            userCredentialsStorage: userCredentialsStorage,
            onTransactionEndHelper: onTransactionEndHelper
        )
        let coordinator = WalletFlowCoordinator(router: delegate)
        viewModel.coordinator = coordinator
        let view = WalletView(viewModel: viewModel)
        return view
    }
}
