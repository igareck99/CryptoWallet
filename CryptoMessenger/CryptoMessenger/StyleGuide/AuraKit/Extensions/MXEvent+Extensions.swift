import MatrixSDK

// MARK: - MXEvent ()

extension MXEvent {

    // MARK: - Internal Properties

    var messageType: MessageType {
        let messageType = content["msgtype"] as? String
        var type: MessageType
        switch messageType {
        case kMXMessageTypeText:
            type = .text(text)
        case kMXMessageTypeImage:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content["url"] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .image(url)
        case kMXMessageTypeFile:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content["url"] as? String ?? ""
            let fileName = content["body"] as? String ?? "Файл"
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .file(fileName, url)
        default:
            type = .none
        }
        return type
    }

    var timestamp: Date { Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000)) }

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
        .init(
            id: eventId,
            type: messageType,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser
        )
    }
}
