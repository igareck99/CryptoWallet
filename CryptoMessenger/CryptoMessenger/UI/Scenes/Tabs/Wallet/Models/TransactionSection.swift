import Foundation

// MARK: - TransactionSection

struct TransactionSection: Identifiable, Hashable, Equatable {
	let id = UUID()
	let info: TransactionInfo
	let details: TransactionDetails
}
