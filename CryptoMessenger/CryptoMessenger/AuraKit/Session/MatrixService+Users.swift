import Foundation
import MatrixSDK

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
	func getAvatarUrl() -> String {
		session?.myUser.avatarUrl ?? ""
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
}
