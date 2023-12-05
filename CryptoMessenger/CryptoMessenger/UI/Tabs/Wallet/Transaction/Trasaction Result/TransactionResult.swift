import Foundation

struct TransactionResult {
	let title: String
	let resultImageName: String
	let amount: String
	let receiverName: String
	let receiversWallet: String
    let result: Result

    let transferAmount: String
    let transferCurrency: String
    let comissionAmount: String
    let comissionCurrency: String
    let cryptoType: String
    let txHash: String?

	static let mock = TransactionResult(
        title: "Перевод выполнен",
        resultImageName: R.image.transaction.successOperation.name,
        amount: "200 BTC",
        receiverName: "Марина Антоненко",
        receiversWallet: "0xSf13S...3dfasfAgfj1",
        result: .success,
        transferAmount: "200",
        transferCurrency: "BTC",
        comissionAmount: "2",
        comissionCurrency: "ETH",
        cryptoType: "BTC",
        txHash: "0xS3dfasfAgfj1S3dfasfAgfj1f13S3dfasfAgfj1f13S3dfasfAgfj1"
    )

    enum Result {
        case success
        case fail(String)
    }
}
