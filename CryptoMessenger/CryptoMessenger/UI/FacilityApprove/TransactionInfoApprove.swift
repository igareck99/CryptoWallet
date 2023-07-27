import SwiftUI

struct TransactionInfoApprove: Identifiable, Equatable {

	let id = UUID()
	var userImage: Image
	var nameSurname: String
	var type: TransactionType
	var date: String
	var fiatValue: String
	var addressFrom: String
	var commission: String
	var transactionCoin: WalletType
	var amount: Double
}
