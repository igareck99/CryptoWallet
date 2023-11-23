import SwiftUI
import MatrixSDK

// swiftlint:disable all

// MARK: - MXEventCustomEvent

enum MXEventCustomEvent {

    // MARK: - Types

    case contactInfo
    case cryptoSend

    // MARK: - Internal Properties

    var identifier: String {
        switch self {
        case .contactInfo:
            return "ms.aura.contact"
        case .cryptoSend:
            return "ms.aura.pay"
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
    case userId
    case name
    case phone
    case mxId
    case info
    case thumbnailUrl = "thumbnail_url"
    case thumbnailInfo = "thumbnail_info"
    case newContent = "m.new_content"
    case eventId = "event_id"
    case relatesTo = "m.relates_to"
    case inReplyTo = "m.in_reply_to"
    case customContent = "m.reply_to"
    case rootUserId = "root_user_id"
    case rootMessage = "root_message"
    case rootEventId = "root_event_id"
    case rootLink = "root_link"
    case amount
    case date
    case receiver
    case sender
    case hash
    case block
    case status
    case currency
}

// swiftlint:disable all

// MARK: - MXEvent ()

extension MXEvent {

    // MARK: - Internal Properties

    var messageType: MessageType {
        let messageType = content[.messageType] as? String
        var type: MessageType
        let homeServer = Configuration.shared.matrixURL

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
        case kMXMessageTypeVideo:
            if getVideo() {
                let link = content[.url] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .video(url)
            } else {
                type = .none
            }
        case kMXMessageTypeAudio:
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .audio(url)
        case kMXMessageTypeImage:
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .image(url)
        case kMXMessageTypeLocation:
            let latitude = content[.latitude] as? String ?? ""
            let longitude = content[.longitude] as? String ?? ""
            type = .location((lat: Double(latitude) ?? 0, long: Double(longitude) ?? 0))
        case kMXMessageTypeFile:
            let link = content[.url] as? String ?? ""
            let fileName = content[.body] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .file(fileName, url)
        case MXEventCustomEvent.contactInfo.identifier:
            let link = content[.avatar] as? String ?? ""
            let name = content[.name] as? String ?? ""
            let phone = content[.phone] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .contact(name: name, phone: phone, url: url)
        default:
                if eventType == .callAnswer ||
                    eventType == .callHangup ||
                    eventType == .callReject {
                    type = .call
                } else {
                    type = .none
                }
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
    
    var audioDuration: String {
        var data = content["info"] as? [String: Any]
        let msc = content["org.matrix.msc1767.audio"] as? [String: Any]
        if msc != nil {
            data = msc
        }
        if data != nil {
            let duration = data?["duration"] as? Int ?? 0
            let time = intToDate(duration)
            return time
        } else {
            return ""
        }
    }
    
    var videoThumbnail: URL? {
        let homeServer = Configuration.shared.matrixURL
        let data = content[.info] as? [String: Any]
        let thumbnailLink = data?[.thumbnailUrl] as? String ?? ""
        let url = MXURL(mxContentURI: thumbnailLink)?.contentURL(on: homeServer)
        return url
    }

    var replyDescription: String {
        var data = content[.relatesTo] as? [String: Any]
        if data != nil {
            return "sent to contact"
        }
        if text.contains(">") {
            let startIndex = text.index(text.lastIndex(of: ">") ?? text.startIndex, offsetBy: 2)
            let data = String(text.suffix(from: startIndex))
            let isReply = data.split(separator: "\n")
            if isReply.count == 1 {
                return "sent to contact"
            }
            return data
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
        case .callHangup, .callReject, .custom, .roomAvatar, .roomCreate, .roomMember:
			return rowItem(isFromCurrentUser)
		default:
			return nil
		}
    }

    // MARK: - Private Methods

    private func rowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
        .init(
            id: eventId,
			sender: sender,
            type: messageType,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser,
            isReply: isReply(),
            replyDescription: replyDescription,
            audioDuration: audioDuration,
			content: content,
			eventType: type
        )
    }
    
    private func getVideo() -> Bool {
        let availabilityFacade = ChatRoomViewModelAssembly.build()
        return availabilityFacade.isVideoMessageAvailable
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
			sender: sender,
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
