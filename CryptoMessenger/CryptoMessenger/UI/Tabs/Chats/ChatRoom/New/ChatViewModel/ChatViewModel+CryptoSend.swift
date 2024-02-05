import Combine
import Foundation
import SwiftUI

// MARK: - Crypto Send

extension ChatViewModel {

    func sendCryptoEvent(rawTransaction: TransactionResult) {
        let currentUserId: String = matrixUseCase.getUserId()

        let model = TransferCryptoEvent(
            amount: rawTransaction.transferAmount,
            currency: rawTransaction.transferCurrency,
            fee: rawTransaction.comissionAmount,
            feeCurrency: rawTransaction.comissionCurrency,
            date: Date().timeIntervalSince1970,
            receiver: rawTransaction.receiverName,
            sender: currentUserId,
            hash: rawTransaction.txHash ?? "",
            block: "block",
            status: "status",
            cryptoType: rawTransaction.cryptoType
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
            Task {
                let wallets = await self.coreDataService.getWalletNetworks()
                let tokens = await self.coreDataService.getNetworksTokens()
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
                await MainActor.run {
                    self.coordinator.transferCrypto(
                        wallet: wallet,
                        receiverData: receiverData
                    ) { [weak self] rawTransaction in
                        guard let self = self else { return }
                        self.sendCryptoEvent(rawTransaction: rawTransaction)
                    }
                }
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
