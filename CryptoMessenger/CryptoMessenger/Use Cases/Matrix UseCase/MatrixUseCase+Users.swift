import Foundation

extension MatrixUseCase {
    func getUserId() -> String {
        matrixService.getUserId()
    }

    func getUser(_ id: String) -> MXUser? {
        matrixService.getUser(id)
    }

    func allUsers() -> [MXUser] {
        matrixService.allUsers()
    }

    func fromCurrentSender(_ userId: String) -> Bool {
        matrixService.fromCurrentSender(userId)
    }

    func searchUser(_ id: String, completion: @escaping GenericBlock<String?>) {
        matrixService.searchUser(id, completion: completion)
    }

    func getDisplayName() -> String {
        matrixService.getDisplayName()
    }

    func getStatus() -> String {
        matrixService.getStatus()
    }

    func getAvatarUrl(completion: @escaping (String) -> Void) {
        matrixService.getAvatarUrl { result in
            completion(result)
        }
    }

    func setDisplayName(_ displayName: String, completion: @escaping VoidBlock) {
        matrixService.setDisplayName(displayName, completion: completion)
    }

    func setStatus(_ status: String, completion: @escaping VoidBlock) {
        matrixService.setStatus(status, completion: completion)
    }

    func setUserAvatarUrl(_ data: Data, completion: @escaping GenericBlock<URL?>) {
        matrixService.uploadUser(data: data) { [weak self] url in
            
            guard let avatarUrl = url else { completion(nil); return }
            
            self?.matrixService.setUser(avatarUrl: avatarUrl) { [weak self] result in
                
                guard let self = self,
                      case .success = result  else { completion(nil); return }
                
                let homeServer = self.config.matrixURL
                let url = MXURL(mxContentURI: avatarUrl)?.contentURL(on: homeServer)
                completion(url)
            }
        }
    }

    func inviteUser(
        userId: String,
        roomId: String,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.inviteUser(userId: userId, roomId: roomId, completion: completion)
    }

    func kickUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        matrixService.kickUser(userId: userId, roomId: roomId, reason: reason, completion: completion)
    }

    func banUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        matrixService.banUser(userId: userId, roomId: roomId, reason: reason, completion: completion)
    }

    func unbanUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock) {
        matrixService.unbanUser(userId: userId, roomId: roomId, completion: completion)
    }

    func leaveRoom(roomId: String, completion: @escaping EmptyResultBlock) {
        matrixService.leaveRoom(roomId: roomId, completion: completion)
    }

    func updateUserPowerLevel(
        userId: String,
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.updateUserPowerLevel(
            userId: userId,
            roomId: roomId,
            powerLevel: powerLevel,
            completion: completion
        )
    }

    func updateUsersPowerLevel(
        userIds: [String],
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.updateUsersPowerLevel(
            userIds: userIds,
            roomId: roomId,
            powerLevel: powerLevel,
            completion: completion
        )
    }
}
