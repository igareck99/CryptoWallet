import Foundation

struct TransactionTemplateRequestParams: Codable {
	let publicKey: String
	let addressTo: String
    let tokenAddress: String?
	let amount: String
	let fee: String
	let cryptoType: String
    
    init(
        publicKey: String,
        addressTo: String,
        tokenAddress: String? = nil,
        amount: String,
        fee: String,
        cryptoType: String
    ) {
        self.publicKey = publicKey
        self.addressTo = addressTo
        self.tokenAddress = tokenAddress
        self.amount = amount
        self.fee = fee
        self.cryptoType = cryptoType
    }
}
