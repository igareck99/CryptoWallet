import Foundation

struct TransactionSection: Identifiable, Hashable, Equatable {
	let id = UUID()
    let address: String
    let cryptoType: CryptoType
    let walletType: WalletType
    let tokenAddress: String?
	let info: TransactionInfo
	let details: TransactionDetails

    init(
        address: String,
        cryptoType: CryptoType,
        walletType: WalletType,
        tokenAddress: String? = nil,
        info: TransactionInfo,
        details: TransactionDetails
    ) {
        self.address = address
        self.cryptoType = cryptoType
        self.walletType = walletType
        self.tokenAddress = tokenAddress
        self.info = info
        self.details = details
    }
}
