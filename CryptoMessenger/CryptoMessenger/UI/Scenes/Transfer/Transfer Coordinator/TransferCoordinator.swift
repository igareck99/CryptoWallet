import SwiftUI

final class TransferCoordinator<Router: TransferRoutable> {
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let wallet: WalletInfo
    private let onFinish: (Coordinator) -> Void

    init(
        wallet: WalletInfo,
        router: Router,
        onFinish: @escaping (Coordinator) -> Void
    ) {
        self.wallet = wallet
        self.router = router
        self.onFinish = onFinish
    }
}

// MARK: - Coordinator

extension TransferCoordinator: Coordinator {
    func start() {
        router.transfer(wallet: wallet, coordinator: self)
    }
    
    func startWithView(completion: @escaping (any View) -> Void) {
        
    }
}

// MARK: - TransferViewCoordinatable

extension TransferCoordinator: TransferViewCoordinatable {
    func chooseReceiver(address: Binding<UserReceiverData>) {
        router.chooseReceiver(address: address, coordinator: self)
    }

    func didCreateTemplate(transaction: FacilityApproveModel) {
        router.facilityApprove(transaction: transaction, coordinator: self)
    }
}

// MARK: - FacilityApproveViewCoordinatable

extension TransferCoordinator: FacilityApproveViewCoordinatable {
    func onTransactionEnd(model: TransactionResult) {
        router.popToRoot()
        delay(0.7) { [weak self] in
            guard let self = self else { return }
            self.router.showTransactionResult(model: model)
            self.onFinish(self)
        }
    }
}

// MARK: - ChooseReceiverViewCoordinatable

extension TransferCoordinator: ChooseReceiverViewCoordinatable {

}
