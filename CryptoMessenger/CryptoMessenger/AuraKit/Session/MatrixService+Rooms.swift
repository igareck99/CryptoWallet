import Foundation
import MatrixSDK

// MARK: - Rooms

extension MatrixService {

	func startListeningForRoomEvents() {
		listenReference = session?.listenToEvents { [weak self] event, direction, roomState in
			guard let self = self else { return }

			let affectedRooms = self.rooms
				.filter { $0.summary.roomId == event.roomId }

			affectedRooms.forEach {
				$0.add(event: event, direction: direction, roomState: roomState as? MXRoomState)
			}
			self.objectChangePublisher.send()
		}
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
			debugPrint("Place_Call: response: \(response)")
			switch response {
			case .success(let call):
				completion(.success(call))
			case .failure(_):
				debugPrint("Place_Call: placeVoiceCall: voiceCallPlaceError")
				completion(.failure(.voiceCallPlaceError))
			}
		}
	}
}
