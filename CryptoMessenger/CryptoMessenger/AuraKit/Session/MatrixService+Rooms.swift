import Foundation
import UIKit

// MARK: - Rooms

extension MatrixService {

	func startListeningForRoomEvents() {
		debugPrint("MatrixService: startListeningForRoomEvents: session: \(self.session)")
		listenReference = session?.listenToEvents { [weak self] event, direction, roomState in
			guard let self = self else { return }
			debugPrint("MatrixService: startListeningForRoomEvents: rooms:  \(self.rooms)")
			debugPrint("MatrixService: startListeningForRoomEvents: event:  \(event.eventType) : \(event.type)")
			let affectedRooms = self.rooms
				.filter { $0.summary.roomId == event.roomId }

			affectedRooms.forEach {
				$0.add(event: event, direction: direction, roomState: roomState as? MXRoomState)
			}
			self.objectChangePublisher.send()
		}
		objectChangePublisher.send()
	}

	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void) {
		session?.createRoom(parameters: parameters) { [weak self] response in
			completion(response)
			self?.objectChangePublisher.send()
		}
	}

	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>) {
		uploader?.uploadData(data, filename: nil, mimeType: "image/jpeg", success: { link in
			guard let link = link, let url = URL(string: link) else {
				completion(nil)
				return
			}
			completion(url)
		}, failure: { _ in
			completion(nil)
		})
	}

    func uploadVoiceMessage(for roomId: String,
                            url: URL,
                            duration: UInt,
                            completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.audioUploadError)); return
        }
        var localEcho: MXEvent?
        room.sendVoiceMessage(localURL: url,
                              mimeType: "audio/ogg",
                              duration: duration,
                              samples: [],
                              localEcho: &localEcho) { response in
            switch response {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                completion(.failure(.audioUploadError))
            }
        }
    }

	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void) {
		session?.leaveRoom(roomId, completion: completion)
	}

	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void) {
		session?.joinRoom(roomId, completion: completion)
	}

	func isDirectRoomExists(userId: String) -> Bool {
		session?.directJoinedRoom(withUserId: userId) != nil
	}

	func placeVoiceCall(
		roomId: String,
		completion: @escaping (Result<MXCall, MXErrors>) -> Void
	) {
		guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room
		else { completion(.failure(.voiceCallPlaceError)); return }

		room.placeCall(withVideo: false) { response in
			debugPrint("Place_Voice_Call: response: \(response)")
			switch response {
			case .success(let call):
				completion(.success(call))
			case .failure(_):
				debugPrint("Place_Voice_Call: placeVoiceCall: voiceCallPlaceError")
				completion(.failure(.voiceCallPlaceError))
			}
		}
	}

	func placeVideoCall(
		roomId: String,
		completion: @escaping (Result<MXCall, MXErrors>) -> Void
	) {
		guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room
		else { completion(.failure(.videoCallPlaceError)); return }

		room.placeCall(withVideo: true) { response in
			debugPrint("Place_Video_Call: response: \(response)")
			switch response {
			case .success(let call):
				completion(.success(call))
			case .failure(_):
				debugPrint("Place_Video_Call: placeVideoCall: voiceCallPlaceError")
				completion(.failure(.videoCallPlaceError))
			}
		}
	}

    func uploadImage(for roomId: String, image: UIImage,
                     completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.imageUploadError)); return
        }
        let fixedImage = image.fixOrientation()
        guard let imageData = fixedImage.jpeg(.medium) else { return }

        var localEcho: MXEvent?
        room.sendImage(
            data: imageData,
            size: image.size,
            mimeType: "image/jpeg",
			thumbnail: image,
			blurhash: nil,
            localEcho: &localEcho
        ) { response in
            switch response {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                debugPrint("s,ldsodsdd  \(error)")
                completion(.failure(.imageUploadError))
            default:
                break
            }
        }
    }

    func uploadFile(for roomId: String, url: URL,
                    completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.fileUploadError)); return
        }
        var localEcho: MXEvent?
        room.sendFile(
            localURL: url,
            mimeType: "file/pdf",
            localEcho: &localEcho
        ) { response in
            switch response {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                debugPrint(error)
                completion(.failure(.fileUploadError))
            }
        }
    }

    func uploadContact(for roomId: String,
                       contact: Contact,
                       completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.contactUploadError)); return
        }
        var localEcho: MXEvent?
        var content: [String: Any] = [:]
        content[.messageType] = MXEventCustomEvent.contactInfo.identifier
        content[.name] = contact.name
        content[.phone] = contact.phone
        content[.avatar] = contact.avatar?.absoluteString ?? ""
        content[.body] = ""
        room.sendMessage(withContent: content, localEcho: &localEcho) { response in
            switch response {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                debugPrint(error)
                completion(.failure(.contactUploadError))
            }
        }
    }
}
