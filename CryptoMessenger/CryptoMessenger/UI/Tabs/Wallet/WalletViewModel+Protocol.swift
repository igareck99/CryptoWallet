import Foundation

// MARK: - WalletViewModelProtocol

extension WalletViewModel: WalletViewModelProtocol {
    func onAppear() {
        Task {
            await updateWallets()
            await updateUserWallet()
            await MainActor.run {
                objectWillChange.send()
            }
        }
    }

    func onWalletCardTap(wallet: WalletInfo) {
        guard let item = cardsList.first(where: { $0.address == wallet.address }) else {
            return
        }
        coordinator?.onTokenInfo(wallet: wallet)
    }

    func showAddSeed() {
        coordinator?.onImportKey { [weak self] in
            guard let self = self else { return }
            Task {
                await self.updateWallets()
                await self.updateUserWallet()
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
    }

    func onTransfer(walletIndex: Int) {
        guard let wallet = cardsList[safe: walletIndex] else {
            return
        }
        coordinator?.onTransfer(wallet: wallet)
    }

    func transactionsList(index: Int) -> [TransactionSection] {
        guard let wallet = cardsList[safe: index],
              let currentTransactions = transactions[wallet.walletType] else {
            return []
        }
        return currentTransactions
    }

    func tryToLoadNextTransactions(offset: CGFloat, pageIndex: Int) {
        guard let currentWallet: WalletInfo = cardsList[safe: pageIndex],
              let currentTransactions: [TransactionSection] = transactions[currentWallet.walletType],
              (CGFloat(currentTransactions.count) * 65) < offset + 420 else {
            return
        }

        guard let lastTransaction: TransactionSection = currentTransactions.last,
              let cryptoType = CryptoType(rawValue: currentWallet.walletType.rawValue) else {
            return
        }

        let transaction = WalletTransactions(
            cryptoType: cryptoType,
            address: currentWallet.address,
            date: lastTransaction.info.date
        )
        let params = TransactionsRequestParams(walletTransactions: [transaction])

        Task {
            let response = await walletNetworks.requestTransactions(params: params)
            guard let wTransactions: WalletsTransactionsResponse = response.model?.value else {
                return
            }

            let nTokens: [NetworkToken] = await coreDataService.getNetworksTokens()
            let transactionsSections: TransactionSections = walletModelsFactory.makeTransactions(
                networkTokens: nTokens,
                model: wTransactions
            )
            let transactionsSection = transactionsSections.sections[currentWallet.walletType] ?? []
            transactions[currentWallet.walletType]?.append(contentsOf: transactionsSection)
            await MainActor.run {
                objectWillChange.send()
            }
        }
    }
}
