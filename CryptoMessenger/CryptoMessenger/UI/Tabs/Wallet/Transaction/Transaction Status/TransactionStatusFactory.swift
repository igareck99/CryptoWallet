import Foundation

protocol TransactionStatusFactoryProtocol {
    static func makeModel(event: RoomEvent) -> TransactionStatus
}

enum TransactionStatusFactory: TransactionStatusFactoryProtocol {
    static func makeModel(event: RoomEvent) -> TransactionStatus {

        let amount: String = event.content[.amount] as? String ?? ""
        let currency: String = event.content[.currency] as? String ?? ""
        let receiver: String = event.content[.receiver] as? String ?? ""
        let sender: String = event.content[.sender] as? String ?? ""
        let hash: String = event.content[.hash] as? String ?? ""
        let block: String = event.content[.block] as? String ?? ""
        let status: String = event.content[.status] as? String ?? ""
        let dateStr: String = event.formattedDate

        let model = TransactionStatus(
            senderAddress: sender,
            receiverAddress: receiver,
            block: block,
            transactionHash: hash,
            dateStr: dateStr,
            amount: amount,
            currency: currency,
            status: status
        )

        return model
    }
}
