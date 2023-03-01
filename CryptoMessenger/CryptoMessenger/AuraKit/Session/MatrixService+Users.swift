import Foundation

// MARK: - Users

extension MatrixService {

	func currentlyActive(_ userId: String) -> Bool {
		session?.user(withUserId: userId)?.currentlyActive ?? false
	}

	func fromCurrentSender(_ userId: String) -> Bool {
		credentials?.userId == userId
		//session?.crypto.backup
		//бэкапы ключей чатов
	}

	func getUser(_ id: String) -> MXUser? {
		session?.user(withUserId: id)
	}
	func getUserId() -> String {
		session?.myUser?.userId ?? ""
	}
	func getDisplayName() -> String {
		session?.myUser?.displayname ?? ""
	}
	func getStatus() -> String {
		session?.myUser?.statusMsg ?? ""
	}
	func getAvatarUrl(completion: @escaping (String) -> Void) {
		let avatar = session?.myUser?.avatarUrl ?? ""
        completion(avatar)
	}

	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock) {
		session?.myUser.setDisplayName(displayName, success: completion) { [weak self] error in
			if let error = error {
				debugPrint(error)
			}
			self?.objectChangePublisher.send()
		}
	}

	func setStatus(_ status: String, completion: @escaping VoidBlock) {
		session?.myUser.setPresence(
			.unavailable,
			andStatusMessage: status,
			success: completion
		) { [weak self] _ in
			self?.objectChangePublisher.send()
		}
	}

	func uploadUser(data: Data, completion: @escaping GenericBlock<String?>) {
		uploader?.uploadData(data, filename: nil, mimeType: "image/jpeg", success: { [weak self] link in
			completion(link)
			self?.objectChangePublisher.send()
		}, failure: { [weak self] _ in
			completion(nil)
			self?.objectChangePublisher.send()
		})
	}

	func setUser(avatarUrl: String, completion: @escaping EmptyResultBlock) {
		session?.myUser.setAvatarUrl(
			avatarUrl,
			success: { [weak self] in
				self?.objectChangePublisher.send()
				completion(.success)
			},
			failure: { [weak self] _ in
				self?.objectChangePublisher.send()
				completion(.failure)
		})
	}

	func allUsers() -> [MXUser] {
		session?.users().filter { $0.userId != session?.myUserId } ?? []
	}

	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>) {
		session?.matrixRestClient.profile(forUser: id) { result in
			switch result {
			case let .success((name, _)):
				if let name = name {
					completion(name)
				} else {
					completion(id)
				}
			default:
				completion(nil)
			}
		}
	}
    
    func inviteUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock ) {
        client?.invite(.userId(userId), toRoom: roomId) { response in
            guard case .success = response else { completion(.failure); return }
            completion(.success)
        }
    }
    
    func kickUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        client?.kickUser(userId, fromRoom: roomId, reason: reason) { response in
            guard case .success = response else { completion(.failure); return }
            completion(.success)
        }
    }
    
    func banUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        client?.banUser(userId, fromRoom: roomId, reason: reason) { response in
            guard case .success = response else { completion(.failure); return }
            completion(.success)
        }
    }
    
    func unbanUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock) {
        client?.unbanUser(userId, fromRoom: roomId) { response in
            guard case .success = response else { completion(.failure); return }
            completion(.success)
        }
    }
    
    func leaveRoom(roomId: String, completion: @escaping EmptyResultBlock) {
        client?.leaveRoom(roomId) {response in
            guard case .success = response else { completion(.failure); return }
            completion(.success)
        }
    }
    
    func updateUserPowerLevel(
        userId: String,
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    ) {
        
        let matrixRoom = rooms.first(where: { $0.room.roomId == roomId })?.room
        guard let room = matrixRoom else { completion(.failure); return }
        
        room.setPowerLevel(
            ofUser: userId,
            powerLevel: powerLevel
        ) { result in
            debugPrint("room.setPowerLevel result: \(result)")
            guard case .success = result else { completion(.failure); return }
            completion(.success)
        }
    }
}
