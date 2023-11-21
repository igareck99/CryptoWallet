import Foundation

struct TransferCryptoEvent: Codable {
    let amount: String
    let date: TimeInterval
    let receiver: String
    let sender: String
}

// MARK: - CustomEvent

extension TransferCryptoEvent: CustomEvent {

    func encodeContent() throws -> [String: Any] {
        [
            "body": [
                "msgType": "ms.aura.pay",
                "msgtype": "ms.aura.pay",
                "amount": amount,
                "date": date,
                "receiver": receiver,
                "sender": sender
            ] as [String: Any],
            "m.new_content": [
                "msgType": "ms.aura.pay",
                "msgtype": "ms.aura.pay",
                "amount": amount,
                "date": date,
                "receiver": receiver,
                "sender": sender
            ] as [String: Any],
//            "m.relates_to": [ ],
            "msgType": "ms.aura.pay",
            "msgtype": "ms.aura.pay"
        ]
    }
}
