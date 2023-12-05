import SwiftUI

final class TransferCoordinator<Router: TransferRoutable> {
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    private let wallet: WalletInfo
    private let onFinish: (Coordinator, TransactionResult) -> Void
    private var receiverData: UserReceiverData?

    init(
        wallet: WalletInfo,
        router: Router,
        receiverData: UserReceiverData? = nil,
        onFinish: @escaping (Coordinator, TransactionResult) -> Void
    ) {
        self.wallet = wallet
        self.router = router
        self.receiverData = receiverData
        self.onFinish = onFinish
    }
}

// MARK: - Coordinator

extension TransferCoordinator: Coordinator {
    func start() {
        router.transfer(
            wallet: wallet,
            coordinator: self,
            receiverData: receiverData
        )
    }
}

// MARK: - TransferViewCoordinatable

extension TransferCoordinator: TransferViewCoordinatable {
    func showAdressScanner(_ value: Binding<String>) {
        router.showAdressScanner(value)
    }

    func chooseReceiver(address: Binding<UserReceiverData>) {
        router.chooseReceiver(address: address, coordinator: self)
    }

    func didCreateTemplate(transaction: FacilityApproveModel) {
        router.facilityApprove(transaction: transaction, coordinator: self)
    }

    func previousScreen() {
        router.previousScreen()
    }
}

// MARK: - FacilityApproveViewCoordinatable

extension TransferCoordinator: FacilityApproveViewCoordinatable {
    func onTransactionEnd(model: TransactionResult) {
        router.popToRoot()
        delay(0.7) { [weak self] in
            guard let self = self else { return }
            self.router.showTransactionResult(model: model)
            self.onFinish(self, model)
        }
    }
}
