import MatrixSDK
import SwiftUI

// swiftlint:disable all

// MARK: - MXEventCustomEvent

enum MXEventCustomEvent {

    // MARK: - Types

    case contactInfo

    // MARK: - Internal Properties

    var identifier: String {
        switch self {
        case .contactInfo:
            return "MXMessageTypeContact"
        }
    }
}

// MARK: - MXEventEventKey

enum MXEventEventKey: String {

    // MARK: - Types

    case messageType = "msgtype"
    case url
    case latitude
    case longitude
    case body
    case avatar
    case name
    case phone
    case newContent = "m.new_content"
    case eventId = "event_id"
    case relatesTo = "m.relates_to"
    case customContent = "m.reply_to"
    case rootUserId = "root_user_id"
    case rootMessage = "root_message"
    case rootEventId = "root_event_id"
    case rootLink = "root_link"
}

// MARK: - Dictionary (ExpressibleByStringLiteral)

extension Dictionary where Key: ExpressibleByStringLiteral {

    // MARK: - Subscript

    subscript(_ eventKey: MXEventEventKey) -> Value? {
        get {
            guard let key = eventKey.rawValue as? Key else { return nil }
            return self[key]
        }
        set {
            guard let key = eventKey.rawValue as? Key else { return }
            self[key] = newValue
        }
    }
}

// MARK: - MXEvent ()

extension MXEvent {

    // MARK: - Internal Properties

    var messageType: MessageType {
        let messageType = content[.messageType] as? String
        var type: MessageType

        switch messageType {
        case kMXMessageTypeText:
            if isReply() {
                let reply = MXReplyEventParser().parse(self)
				type = .text(reply?.bodyParts.replyText ?? "")
            } else if isEdit() {
                type = .none
            } else {
                type = .text(self.text)
            }
        case kMXMessageTypeImage:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .image(url)
        case kMXMessageTypeLocation:
            let latitude = content[.latitude] as? String ?? ""
            let longitude = content[.longitude] as? String ?? ""
            type = .location((lat: Double(latitude) ?? 0, long: Double(longitude) ?? 0))
        case kMXMessageTypeFile:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.url] as? String ?? ""
            let fileName = content[.body] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .file(fileName, url)
        case MXEventCustomEvent.contactInfo.identifier:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.avatar] as? String ?? ""
            let name = content[.name] as? String ?? ""
            let phone = content[.phone] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .contact(name: name, phone: phone, url: url)
        default:
            type = .none
        }

        return type
    }

    var timestamp: Date { Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000)) }

    var text: String {
        if !isEdit() {
            return (content[.body] as? String).map {
                $0
                    .trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        } else {
            let newContent = content[.newContent] as? NSDictionary
            return (newContent?[MXEventEventKey.body] as? String).map {
                $0
                    .trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        }
    }

	// TODO: Посмотреть как работает на расшифрованных сообщениях
	func decryptedText() -> String {
		if !isEdit() {
			let text = (clear.content[.body] as? String).map {
				$0
					.trimmingCharacters(in: .controlCharacters)
					.trimmingCharacters(in: .whitespacesAndNewlines)
			} ?? "Error: expected string body"
			return text
		} else {
			let newContent = clear.content[.newContent] as? NSDictionary
			let text = (newContent?[MXEventEventKey.body] as? String).map {
				$0
					.trimmingCharacters(in: .controlCharacters)
					.trimmingCharacters(in: .whitespacesAndNewlines)
			} ?? "Error: expected string body"
			return text
		}
	}

    var userId: String {
        if content[.customContent] != nil {
            let data = content[.customContent] ?? ""
            let dataDict = data as? [String: String]
            return dataDict?["root_user_id"] ?? ""
        } else {
            return ""
        }
    }

    var replyDescription: String {
        if text.contains(">") {
            let startIndex = text.index(text.lastIndex(of: ">") ?? text.startIndex, offsetBy: 2)
            return String(text.suffix(from: startIndex))
        } else {
            return ""
        }
    }

    // MARK: - Internal Methods

    func content<T>(valueFor key: String) -> T? { content?[key] as? T }

    func prevContent<T>(valueFor key: String) -> T? { unsignedData?.prevContent?[key] as? T }

    func message(_ isFromCurrentUser: Bool) -> RoomMessage? {
		switch eventType {
		case .roomMessage:
			return rowItem(isFromCurrentUser)
		case .roomEncrypted:
			return encryptedRowItem(isFromCurrentUser)
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
            isCurrentUser: isFromCurrentUser,
            isReply: isReply(),
            replyDescription: replyDescription,
			content: content,
			eventType: type
        )
    }

	private func encryptedRowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
		// TODO: Проверить как работает на расшифрованных сообщениях
		let type: MessageType
		if clear == nil {
			type = .text("Не удалось расшифровать сообщение")
		} else {
			type = .text(decryptedText())
		}

		let roomMessage = RoomMessage(
			id: eventId,
			type: type,
			shortDate: timestamp.hoursAndMinutes,
			fullDate: timestamp.dayOfWeekDayAndMonth,
			isCurrentUser: isFromCurrentUser,
			isReply: isReply(),
			replyDescription: replyDescription,
			content: content,
			eventType: self.type
		)
		return roomMessage
	}
}