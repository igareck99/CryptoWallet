import SwiftUI

// MARK: - WalletFlowCoordinatorProtocol

protocol WalletFlowCoordinatorProtocol {
    
    func onTransaction(_ selectorFilterIndex: Int, _ selectorTokenIndex: Int, _ address: String)
    
    func onTransfer(_ wallet: WalletInfo)
    
    func onImportKey()
}

final class WalletFlowCoordinator {
    
   private let router: WalletSceneDelegate
    
    init(router: WalletSceneDelegate) {
        self.router = router
    }
}
    
// MARK: - ContentFlowCoordinatorProtocol

extension WalletFlowCoordinator: WalletFlowCoordinatorProtocol {
    
    func onTransaction(_ selectorFilterIndex: Int, _ selectorTokenIndex: Int, _ address: String) {
        router.handleNextScene(.transaction(selectorFilterIndex,
                                            selectorTokenIndex,
                                            address))
    }
    
    func onImportKey() {
        router.handleNextScene(.importKey)
    }
    
    func onTransfer(_ wallet: WalletInfo) {
        router.handleNextScene(.transfer(wallet: wallet))
    }
}
