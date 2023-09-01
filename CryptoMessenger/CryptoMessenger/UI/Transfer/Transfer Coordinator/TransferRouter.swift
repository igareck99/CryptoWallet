import SwiftUI

protocol TransferRoutable: ObservableObject {
    func transfer(
        wallet: WalletInfo,
        coordinator: TransferViewCoordinatable
    )

    func chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: TransferViewCoordinatable
    )

    func facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: FacilityApproveViewCoordinatable
    )
    
    func showAdressScanner(_ value: Binding<String>)

    func showTransactionResult(model: TransactionResult)

    func popToRoot()
    
    func previousScreen()
}

final class TransferRouter<State: TransferStatable> {

    var state: State

    init(state: State) {
        self.state = state
    }
}

// MARK: - TransferRoutable

extension TransferRouter: TransferRoutable {

    func transfer(
        wallet: WalletInfo,
        coordinator: TransferViewCoordinatable
    ) {
        state.path.append(
            WalletContentLink.transfer(
                wallet: wallet,
                coordinator: coordinator
            )
        )
    }

    func chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: TransferViewCoordinatable
    ) {
        state.path.append(
            WalletContentLink.chooseReceiver(
                address: address,
                coordinator: coordinator
            )
        )
    }

    func facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: FacilityApproveViewCoordinatable
    ) {
        state.path.append(
            WalletContentLink.facilityApprove(
                transaction: transaction,
                coordinator: coordinator
            )
        )
    }
    
    func showAdressScanner(_ value: Binding<String>) {
        state.path.append(
            WalletContentLink.adressScanner(value: value)
        )
    }

    func showTransactionResult(model: TransactionResult) {
        state.presentedItem = WalletSheetLink.transactionResult(model: model)
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }
    
    func previousScreen() {
        state.path.removeLast()
    }
}
