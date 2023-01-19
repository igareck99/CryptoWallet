import Foundation

struct TransactionSection: Identifiable, Equatable {
	let id = UUID()
	let info: TransactionInfo
	let details: TransactionDetails
}
