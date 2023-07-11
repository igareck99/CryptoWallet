import Foundation

struct TransactionResult {
	let title: String
	let resultImageName: String
	let amount: String
	let receiverName: String
	let receiversWallet: String
    let result: Result

	static let mock = TransactionResult(
		title: "Перевод выполнен",
		resultImageName: R.image.transaction.successOperation.name,
		amount: "200 BTC",
		receiverName: "Марина Антоненко",
		receiversWallet: "0xSf13S...3dfasfAgfj1",
        result: .success
	)

    enum Result {
        case success
        case fail(String)
    }
}
