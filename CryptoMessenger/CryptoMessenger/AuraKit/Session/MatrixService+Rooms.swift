import Foundation
import UIKit
import MatrixSDK

// MARK: - Rooms

extension MatrixService {

	func startListeningForRoomEvents() {
		listenReference = session?.listenToEvents { [weak self] event, direction, roomState in
			guard let self = self else { return }
			let affectedRooms = self.rooms
                .filter { $0.summary.summary?.roomId == event.roomId }

			affectedRooms.forEach {
				$0.add(event: event, direction: direction, roomState: roomState as? MXRoomState)
			}
			self.objectChangePublisher.send()
		}
		objectChangePublisher.send()
	}

	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void) {
		session?.createRoom(parameters: parameters) { [weak self] response in
            self?.objectChangePublisher.send()
            self?.session?.updateClientInformation()
			completion(response)
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
                              additionalContentParams: nil,
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

    // Вступил ли пользователь в комнату (p2p, group chat, channel)
    func isAlreadyJoinedRoom(roomId: String) -> Bool? {
        // session?.rooms - это все типы комнат
        guard let room = session?.rooms.first(where: {
            $0.roomId == roomId
        }) else {
            return nil
        }
        let isAlreadyJoined = room.summary?.membership == .join
        return isAlreadyJoined
    }

    // Был ли пользователь приглашен в комнату (p2p, group chat, channel)
    func isInvitedToRoom(roomId: String) -> Bool? {
        // session?.rooms - это все типы комнат
        guard let room = session?.rooms.first(where: {
            $0.roomId == roomId
        }) else {
            return nil
        }
        let isInvited = room.summary?.membership == .invite
        let isFailedJoining = room.summary?.membershipTransitionState == .failedJoining
        let isJoining = room.summary?.membershipTransitionState == .joining
        let isJoined = room.summary?.membershipTransitionState == .joined
        // MARK: - Оставил для дебага
//        debugPrint("MATRIX DEBUG isInvitedToRoom ================================================")
//        debugPrint("MATRIX DEBUG isInvitedToRoom roomId: \(roomId)")
//        debugPrint("MATRIX DEBUG isInvitedToRoom isInvited: \(isInvited)")
//        debugPrint("MATRIX DEBUG isInvitedToRoom tState: \(room.summary?.membershipTransitionState.rawValue)")
//        debugPrint("MATRIX DEBUG isInvitedToRoom room.summary?.membership: \(room.summary?.membership.rawValue)")
//        debugPrint("MATRIX DEBUG isInvitedToRoom ================================================")
        return isInvited && !isFailedJoining && !isJoining && !isJoined
    }

    // Проверяем есть ли комната (p2p) с ползователем
	func isDirectRoomExists(userId: String) -> String? {
        // session?.directRooms - это только p2p комнаты
        // вытаскиваем все идентификаторы p2p комнат, которые есть с этим пользователем
        let ids: Set<String> = Set(session?.directRooms[userId] ?? [])
        let mxRooms: [MXRoom] = (session?.rooms ?? [])
            .filter { ids.contains($0.roomId) }
        let room: MXRoom? = mxRooms.first(where: { mxRoom in
            // проверяем membership в каждой комнате
            // если есть хотя бы одна комната с membership == .join,
            // то комната уже есть и пользователь ее еще не покинул
            mxRoom.summary?.membership == .join
        })
        return room?.roomId
	}

    func getRoomInfo(roomId: String) -> MXRoom? {
        guard let room = matrixSession?.rooms.first(where: {
            $0.roomId == roomId
        }) else {
            return nil
        }
        return room
    }

    func isRoomEncrypted(roomId: String, completion: @escaping (Bool?) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(nil)
            return
        }
        room.state { state in
            completion(state?.isEncrypted)
        }
    }

    func isRoomPublic(roomId: String, completion: @escaping (Bool?) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(nil)
            return
        }
        room.getDirectoryVisibility { result in
            switch result {
            case .success(let value):
                if value == .private {
                    completion(false)
                } else {
                    completion(true)
                }
            case .failure(_):
                break
            }
        }
    }

    func setJoinRule(roomId: String, isPublic: Bool,
                     completion: @escaping (MXResponse<Void>?) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(nil)
            return
        }
        let joinRule: MXRoomJoinRule = isPublic ? .public : .private
        room.setJoinRule(joinRule) { result in
            completion(result)
        }
    }

    func setRoomState(roomId: String,
                      isPublic: Bool,
                      completion: @escaping (MXResponse<Void>?) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(nil)
            return
        }
        let state: MXRoomDirectoryVisibility = isPublic ? .public : .private
        room.setDirectoryVisibility(state) { response in
            completion(response)
        }
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
        guard let imageData = fixedImage.jpeg(.highest) else { return }

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
        content[.mxId] = contact.mxId
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

    func enableEncryptionWithAlgorithm(roomId: String,
                                       completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.encryptRoomError)); return
        }
        room.enableEncryption(withAlgorithm: "") { response in
            switch response {
            case let .success(result):
                completion(.success("Is Encrypted"))
            case let .failure(error):
                completion(.failure(.encryptRoomError))
            }
        }
    }

    func uploadVideoMessage(for roomId: String,
                            url: URL,
                            thumbnail: MXImage?,
                            completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.videoUploadError)); return
        }
        var localEcho: MXEvent?
        url.generateThumbnail { image in
            guard let image = image else { return }
            room.sendVideo(localURL: url,
                           thumbnail: image,
                           localEcho: &localEcho) { response in
                switch response {
                case let .success(result):
                    completion(.success(result))
                case let .failure(error):
                    debugPrint(error)
                    completion(.failure(.videoUploadError))
                }
            }
        }
    }

    func sendText(_ roomId: String,
                  _ text: String,
                  completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard !text.isEmpty else { return }
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.sendTextError)); return
        }
        var localEcho: MXEvent?
        room.sendTextMessage(text, localEcho: &localEcho) { response in
            switch response {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                debugPrint(error)
                completion(.failure(.sendTextError))
            }
        }
    }

    func sendReply(_ text: String,
                   _ roomId: String,
                   _ eventId: String,
                   _ customParameters: [String: Any],
                   completion: @escaping (Result <String?, MXErrors>) -> Void) {
        guard let matrixRoom = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.sendReplyError))
            return
        }
        var localEcho: MXEvent?
        matrixSession?.event(withEventId: eventId,
                             inRoom: roomId, { result in
            switch result {
            case let .success(event):
                if let longitude = event.content["longitude"],
                   let latitude = event.content["latitude"] {
                    event.wireContent["geo_uri"] = "geo:\(latitude),\(longitude)"
                }
                matrixRoom.sendReply(to: event,
                                     textMessage: text,
                                     formattedTextMessage: nil,
                                     stringLocalizations: nil,
                                     localEcho: &localEcho,
                                     customParameters: customParameters) { _ in
                    completion(.success("Reply Send"))
                }
            case let .failure(error):
                completion(.failure(.sendReplyError))
            }
        })
    }

    func sendLocation(
        roomId: String,
        location: LocationData?,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        guard let unwrappedLocation = location,
              let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            completion(.failure(.sendGeoError))
            return
        }

        var localEcho: MXEvent?
        do {
            let content = try LocationEvent(location: unwrappedLocation).encodeContent()
            room.sendMessage(withContent: content, localEcho: &localEcho) { result in
                switch result {
                case .success(let text):
                    completion(.success(text))
                case .failure(_):
                    completion(.failure(.sendGeoError))
                }
            }
        } catch {
            debugPrint("Error create LocationEvent")
        }
    }

    func sendTransferCryptoEvent(
        roomId: String,
        model: TransferCryptoEvent,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        guard let room = rooms.first(
            where: { $0.room.roomId == roomId }
        )?.room else {
            completion(.failure(.sendCryptoError))
            return
        }
        let content = model.encodeContent()
        var localEcho: MXEvent?
        let operation = room.sendMessage(
            withContent: content,
            localEcho: &localEcho
        ) { result in
            switch result {
            case .success(let text):
                completion(.success(text))
            case .failure(_):
                completion(.failure(.sendCryptoError))
            }
        }
        currentOperation = operation
    }

    func markAllAsRead(roomId: String) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            return
        }
        room.markAllAsRead()
    }

    func edit(roomId: String, text: String, eventId: String) {
        guard !text.isEmpty else { return }
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            return
        }
        var localEcho: MXEvent?
        let content = EditEvent(eventId: eventId, text: text).encodeContent()
        // TODO: Use localEcho to show sent message until it actually comes back
        room.sendMessage(withContent: content, localEcho: &localEcho) { _ in }
    }

    func removeReaction(
        roomId: String,
        text: String,
        eventId: String,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixSession?.aggregations.removeReaction(
            text,
            forEvent: eventId,
            inRoom: roomId,
            success: {
                completion(.success("Reaction Removed"))
            }, failure: { _ in
                completion(.failure(.removeReactionFailure))
            })
    }

    func redact(roomId: String,
                eventId: String, reason: String?) {
        guard let room = rooms.first(where: { $0.room.roomId == roomId })?.room else {
            return
        }
        room.redactEvent(eventId, reason: reason) { _ in }
    }

    func getPublicRooms(filter: String,
                        completion: @escaping  (Result <[MXPublicRoom]?, MXErrors>) -> Void) {
        client?.publicRooms(onServer: nil,
                            limit: 100,
                            filter: filter,
                            includeAllNetworks: false,
                            completion: { response in
            switch response {
            case let .success(result):
                completion(.success(result.chunk))
            case let .failure(error):
                debugPrint("getPublicRooms  Error \(error)")
                completion(.failure(.publicRoomError))
            default:
                break
            }
        })
    }
}
