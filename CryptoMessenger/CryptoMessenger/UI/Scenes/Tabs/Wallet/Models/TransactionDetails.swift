import Foundation

// MARK: - TransactionDetails

struct TransactionDetails: Identifiable, Hashable, Equatable {
	let id = UUID()
	let sender: String
	let receiver: String
	let block: String
	let hash: String
}
