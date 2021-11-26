import MatrixSDK

extension MXEvent {
    var timestamp: Date { Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000)) }

    func content<T>(valueFor key: String) -> T? { content?[key] as? T }

    func prevContent<T>(valueFor key: String) -> T? { unsignedData?.prevContent?[key] as? T }

    func message(_ isFromCurrentUser: Bool) -> RoomMessage? {
        switch eventType {
        case .roomMessage:
            return text(isFromCurrentUser)
        default:
            return nil
        }
    }

    private func text(_ isFromCurrentUser: Bool) -> RoomMessage {
        var text: String {
            if !isEdit() {
                return (content["body"] as? String).map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                } ?? "Error: expected string body"
            } else {
                let newContent = content["m.new_content"] as? NSDictionary
                return (newContent?["body"] as? String).map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                } ?? "Error: expected string body"
            }
        }

        return .init(
            id: eventId,
            type: .text(text),
            date: timestamp.hoursAndMinutes,
            isCurrentUser: isFromCurrentUser
        )
    }
}
