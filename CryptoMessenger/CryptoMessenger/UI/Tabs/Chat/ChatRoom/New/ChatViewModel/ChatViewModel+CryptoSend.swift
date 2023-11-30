import Combine
import Foundation
import SwiftUI

// MARK: - Crypto Send

extension ChatViewModel {

    func sendCryptoEvent(rawTransaction: TransactionSendResponse) {
        let currentUserId: String = matrixUseCase.getUserId()
        guard let receiverUserId: String = opponentId() else {
            return
        }

        let model = TransferCryptoEvent(
            amount: "0.000002",
            currency: "ETH",
            date: Date().timeIntervalSince1970,
            receiver: receiverUserId,
            sender: currentUserId,
            hash: rawTransaction.hash,
            block: "block",
            status: "status"
        )
        matrixUseCase.sendTransferCryptoEvent(
            roomId: room.roomId,
            model: model
        ) { [weak self] in
            debugPrint("sendTransferCryptoEvent Result: \($0)")
            debugPrint("sendTransferCryptoEvent Result")
        }
    }

    func onCryptoSendTap(receiverWallet: UserWallletData) {
        coordinator.dismissCurrentSheet()

        delay(0.5) {
            let wallets = self.coreDataService.getWalletNetworks()
            let tokens = self.coreDataService.getNetworksTokens()
            let cards: [WalletInfo] = self.walletModelsFactory.makeDisplayCards(
                wallets: wallets,
                tokens: tokens
            )
            guard let wallet = cards.first(
                where: { $0.walletType == .aura }
            ) else {
                return
            }
            let receiverData = UserReceiverData(
                name: receiverWallet.name,
                url: nil,
                adress: receiverWallet.aura,
                walletType: .aura
            )
            self.coordinator.transferCrypto(
                wallet: wallet,
                receiverData: receiverData
            ) { [weak self] rawTransaction in
                guard let self = self, let rawTx = rawTransaction else { return }
                self.sendCryptoEvent(rawTransaction: rawTx)
            }
        }
    }

    func opponentId() -> String? {
        let currentUserId: String = matrixUseCase.getUserId()
        guard !currentUserId.isEmpty, let receiverUserId: String = participants.first(
            where: { $0.matrixId != currentUserId }
        )?.matrixId else {
            return nil
        }
        return receiverUserId
    }
}
