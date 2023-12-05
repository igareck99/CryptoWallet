import Foundation

struct TransferCryptoEvent: Codable {
    let amount: String
    let currency: String
    let fee: String
    let feeCurrency: String
    let date: TimeInterval
    let receiver: String
    let sender: String
    let hash: String
    let block: String
    let status: String
    let cryptoType: String
}

// MARK: - CustomEvent

extension TransferCryptoEvent: CustomEvent {

    func encodeContent() -> [String: Any] {
        [
            "body": "ms.aura.pay",
            "msgtype": "ms.aura.pay",
            "amount": amount,
            "currency": currency,
            "fee": fee,
            "feeCurrency": feeCurrency,
            "date": "\(date)",
            "receiver": receiver,
            "sender": sender,
            "hash": hash,
            "block": block,
            "status": status,
            "cryptoType": cryptoType
        ]
    }
}
