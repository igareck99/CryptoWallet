import Foundation

struct FacilityApproveModel {
	let reciverName: String?
	let reciverAddress: String?
	let transferAmount: String
	let transferCurrency: String
	let comissionAmount: String
	let comissionCurrency: String

	let derSignature: String
	let index: Int
	let uuid: String
	let cryptoType: String
}
