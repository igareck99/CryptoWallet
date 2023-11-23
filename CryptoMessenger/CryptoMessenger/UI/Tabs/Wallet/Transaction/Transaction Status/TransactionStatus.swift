import Foundation

struct TransactionStatus {
    let senderAddress: String
    let receiverAddress: String
    let block: String
    let transactionHash: String
    let dateStr: String
    let amount: String
    let currency: String
    let status: String

    var keysAndValues: [(leftText: String, rightText: String)] {
        [
            (leftText: "Отправитель", rightText: senderAddress),
            (leftText: "Получатель", rightText: receiverAddress),
            (leftText: "Блок", rightText: block),
            (leftText: "Хэш", rightText: transactionHash),
            (leftText: "Дата", rightText: dateStr),
            (leftText: "Сумма", rightText: amount + " " + currency),
            (leftText: "Статус", rightText: status)
        ]
    }

    init(
        senderAddress: String,
        receiverAddress: String,
        block: String,
        transactionHash: String,
        dateStr: String,
        amount: String,
        currency: String,
        status: String = "Успешно подтверждена" // Ожидает подтверждения
    ) {
        self.senderAddress = senderAddress
        self.receiverAddress = receiverAddress
        self.block = block
        self.transactionHash = transactionHash
        self.dateStr = dateStr
        self.amount = amount
        self.currency = currency
        self.status = status
    }
}
