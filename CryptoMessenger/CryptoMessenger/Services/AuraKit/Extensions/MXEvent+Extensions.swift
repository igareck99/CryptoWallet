import MatrixSDK

// MARK: - MXEvent ()

extension MXEvent {

    // MARK: - Internal Properties

    var timestamp: Date { Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000)) }

    // MARK: - Internal Methods

    func content<T>(valueFor key: String) -> T? { content?[key] as? T }

    func prevContent<T>(valueFor key: String) -> T? { unsignedData?.prevContent?[key] as? T }

    func message(_ isFromCurrentUser: Bool) -> RoomMessage? {
        switch eventType {
        case .roomMessage:
            return rowItem(isFromCurrentUser)
        default:
            return nil
        }
    }

    // MARK: - Private Methods

    private func rowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
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

        let messageType = content["msgtype"] as? String
        var itemType: MessageType
        switch messageType {
        case kMXMessageTypeText:
            itemType = .text(text)
        case kMXMessageTypeImage:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content["url"] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            itemType = .image(url)
        default:
            itemType = .text(text)
        }

        return .init(
            id: eventId,
            type: itemType,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser
        )
    }
}
