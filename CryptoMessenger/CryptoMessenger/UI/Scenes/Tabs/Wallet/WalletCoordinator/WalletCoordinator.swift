import SwiftUI

// MARK: - WalletCoordinatable

protocol WalletCoordinatable: Coordinator {

    // ????
    func onTransaction(_ selectorFilterIndex: Int, _ selectorTokenIndex: Int, _ address: String)

    // Переход на экран перевода
    func onTransfer(_ wallet: WalletInfo)

    // Переход на экран импорта ключа
    func onImportKey()

    // Импорта ключа завершен
    func didImportKey()
    
    /// Отображение информации о кошельке
    /// - Parameter wallet: информация о кошельке
    func onTokenInfo(wallet: WalletInfo)
}

final class WalletCoordinator<Router: WalletRouterable> {
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private let router: Router

    init(router: Router) {
        self.router = router
    }
}

// MARK: - Coordinator

extension WalletCoordinator: Coordinator {
    func start() {
    }
}

// MARK: - WalletCoordinatable

extension WalletCoordinator: WalletCoordinatable {

    func onTransaction(_ selectorFilterIndex: Int, _ selectorTokenIndex: Int, _ address: String) {
        router.transaction(
            filterIndex: selectorFilterIndex,
            tokenIndex: selectorTokenIndex,
            address: address,
            coordinator: self
        )
    }

    func onImportKey() {
        router.importKey(coordinator: self)
    }

    func onTransfer(_ wallet: WalletInfo) {
        let transferCoordinator = TransferCoordinatorAssembly.buld(
            wallet: wallet,
            path: router.routePath(),
            presentedItem: router.presentedItem()
        ) { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
        }
        addChildCoordinator(transferCoordinator)
        transferCoordinator.start()
    }

    func didImportKey() {
        router.popToRoot()
    }
    
    func onTokenInfo(wallet: WalletInfo) {
        // TODO: Implement
    }
}
