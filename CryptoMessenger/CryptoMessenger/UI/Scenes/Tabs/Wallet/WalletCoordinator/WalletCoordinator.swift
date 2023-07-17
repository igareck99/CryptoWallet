import SwiftUI

// MARK: - WalletCoordinatable

protocol WalletCoordinatable {

    // ????
    func onTransaction(_ selectorFilterIndex: Int, _ selectorTokenIndex: Int, _ address: String)

    // Переход на экран перевода
    func onTransfer(_ wallet: WalletInfo)

    // Переход на экран импорта ключа
    func onImportKey()

    // Импорта ключа завершен
    func didImportKey()

    // Выбрали получателя
    func chooseReceiver(address: Binding<UserReceiverData>)

    // Создали template транзакции
    func didCreateTemplate(transaction: FacilityApproveModel)

    // Совершили транзакцию
    func onTransactionEnd(model: TransactionResult)
}

final class WalletCoordinator {

    private let router: WalletRouterable

    init(router: WalletRouterable) {
        self.router = router
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
        router.transfer(wallet: wallet, coordinator: self)
    }

    func chooseReceiver(address: Binding<UserReceiverData>) {
        router.chooseReceiver(address: address, coordinator: self)
    }

    func didImportKey() {
        router.popToRoot()
    }

    func didCreateTemplate(transaction: FacilityApproveModel) {
        router.facilityApprove(
            transaction: transaction,
            coordinator: self
        )
    }

    func onTransactionEnd(model: TransactionResult) {
        router.popToRoot()
        delay(0.7) {
            self.router.showTransactionResult(model: model)
        }
    }
}
