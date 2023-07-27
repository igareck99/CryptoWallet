import Foundation

struct TransactionSpeed: Identifiable {
	let id = UUID()
	let title: String
	let feeText: String
	let feeValue: String
	let mode: TransactionMode
}
