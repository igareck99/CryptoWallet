import Foundation

struct TransactionDetails: Identifiable, Equatable {
	let id = UUID()
	let sender: String
	let receiver: String
	let block: String
	let hash: String
}
