import SwiftUI

enum WalletSheetLink: Identifiable, Hashable {
    case transactionResult(model: TransactionResult)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: WalletSheetLink, rhs: WalletSheetLink) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum WalletContentLink: Identifiable, Hashable {

    case transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    )
    case transfer(
        wallet: WalletInfo,
        coordinator: WalletCoordinatable
    )
    case importKey(coordinator: WalletCoordinatable)
    case chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: WalletCoordinatable
    )
    
    case facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: WalletCoordinatable
    )
    
    // MARK: - Identifiable

    var id: String {
        String(describing: self)
    }

    // MARK: - Equatable
    
    static func == (lhs: WalletContentLink, rhs: WalletContentLink) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
