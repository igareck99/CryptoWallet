import Foundation

extension MatrixUseCase {
    func createChannel(
        name: String,
        topic: String,
        channelType: ChannelType,
        roomAvatar: UIImage?,
        completion: @escaping (RoomCreateState) -> Void
    ) {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = []
        parameters.isDirect = false
        parameters.name = name
        parameters.topic = topic
        if channelType == .publicChannel {
            parameters.visibility = MXRoomDirectoryVisibility.public.identifier
        } else {
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        }
        parameters.preset = MXRoomPreset.privateChat.identifier
        let powerLevelOverride = MXRoomPowerLevels()
        powerLevelOverride.eventsDefault = 50
        powerLevelOverride.stateDefault = 50
        powerLevelOverride.usersDefault = 0
        powerLevelOverride.invite = 50
        parameters.powerLevelContentOverride = powerLevelOverride
        self.createRoom(parameters: parameters, roomAvatar: roomAvatar?.jpeg(.medium)) { result in
            completion(result)
        }
    }

    func createDirectRoom(
        _ ids: [String],
        completion: @escaping (RoomCreateState) -> Void
    ) {
        guard
            ids.count == 1,
            let userId = ids.first,
            !self.isDirectRoomExists(userId: userId)
        else {
            completion(.roomAlreadyExist)
            return
        }
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = ids
        parameters.isDirect = true
        parameters.visibility = kMXRoomDirectoryVisibilityPrivate
        // parameters.preset = MXRoomPreset.privateChat.identifier
        parameters.preset = kMXRoomPresetTrustedPrivateChat
        createRoom(parameters: parameters, completion: { result in
            self.objectChangePublisher.send()
            completion(result)
        })
    }

    func createRoom(
        parameters: MXRoomCreationParameters,
        roomAvatar: Data? = nil,
        completion: @escaping (RoomCreateState) -> Void
    ) {
        self.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case let .success(room):
                completion(.roomCreateSucces)
                guard let data = roomAvatar else {
                    return
                }
                self?.setRoomAvatar(data: data, for: room) { _ in
                    // TODO: Обработать case failure
                    // self?.closeScreen = true
                }
            case let .failure(error):
                completion(.roomCreateError)
            }
        }
    }

    func createGroupRoom(_ info: ChatData, completion: @escaping (RoomCreateState) -> Void) {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = info.contacts.map({ $0.mxId })
        parameters.isDirect = false
        parameters.name = info.title
        parameters.topic = info.description
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        self.createRoom(parameters: parameters, roomAvatar: info.image?.jpeg(.medium), completion: { result in
            completion(result)
        })
    }

    func getRoomAvatarUrl(roomId: String) -> URL? {
        guard let room = getRoomInfo(roomId: roomId),
              let avatar = room.summary.avatar,
              let avatarUrl = MXURL(mxContentURI: avatar)?.contentURL(on: config.matrixURL) else { return nil }

        return avatarUrl
    }

    func getRoomInfo(roomId: String) -> MXRoom? {
        guard let room = matrixSession?.rooms.first(where: {
            $0.roomId == roomId
        }) else {
            return nil
        }
        return room
    }

    func setRoomName(
        name: String,
        roomId: String,
        completion: @escaping (MXResponse<Void>) -> Void
    ) {
        matrixService.matrixSession?.matrixRestClient?
            .setName(ofRoom: roomId, name: name, completion: completion)
    }

    func setRoomTopic(
        topic: String,
        roomId: String,
        completion: @escaping (MXResponse<Void>) -> Void
    ) {
        matrixService.matrixSession?.matrixRestClient?
            .setTopic(ofRoom: roomId, topic: topic, completion: completion)
    }

    func isDirectRoomExists(userId: String) -> Bool {
        matrixService.isDirectRoomExists(userId: userId)
    }

    func isRoomEncrypted(
        roomId: String,
        completion: @escaping (Bool?) -> Void
    ) {
        matrixService.isRoomEncrypted(
            roomId: roomId,
            completion: completion
        )
    }

    func isRoomPublic(roomId: String, completion: @escaping (Bool?) -> Void) {
        matrixService.isRoomPublic(roomId: roomId) { value in
            completion(value)
        }
    }

    func setRoomState(
        roomId: String,
        isPublic: Bool,
        completion: @escaping (MXResponse<Void>?) -> Void
    ) {
        matrixService.setRoomState(roomId: roomId,
                                   isPublic: isPublic) { _ in
        }
    }

    func setJoinRule(
        roomId: String,
        isPublic: Bool,
        completion: @escaping (MXResponse<Void>?) -> Void
    ) {
        matrixService.setJoinRule(roomId: roomId,
                                  isPublic: isPublic) { _ in
        }
    }

    func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void) {
        matrixService.leaveRoom(roomId: roomId, completion: completion)
    }

    func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void) {
        matrixService.joinRoom(roomId: roomId, completion: completion)
    }

    func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void) {
        matrixService.createRoom(parameters: parameters, completion: completion)
    }

    func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>) {
        matrixService.uploadData(data: data, for: room, completion: completion)
    }

    func sendText(
        _ roomId: String,
        _ text: String,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.sendText(roomId,
                               text, completion: completion)
    }

    func markAllAsRead(roomId: String) {
        matrixService.markAllAsRead(roomId: roomId)
    }

    func edit(
        roomId: String,
        text: String,
        eventId: String
    ) {
        matrixService.edit(roomId: roomId, text: text, eventId: eventId)
    }

    func removeReaction(
        roomId: String,
        text: String,
        eventId: String,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.removeReaction(
            roomId: roomId,
            text: text,
            eventId: eventId
        ) { result in
            completion(result)
        }
    }

    func react(eventId: String, roomId: String, emoji: String) {
        matrixSession?.aggregations.addReaction(
            emoji,
            forEvent: eventId,
            inRoom: roomId,
            success: {
                debugPrint("emotions success")
            }, failure: { error in
                debugPrint("emotions error \(error)")
            })
    }

    func redact(
        roomId: String,
        eventId: String,
        reason: String?
    ) {
        matrixService.redact(roomId: roomId, eventId: eventId, reason: reason)
    }

    func sendLocation(
        roomId: String,
        location: LocationData?,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.sendLocation(roomId: roomId,
                                   location: location, completion: completion)
    }

    func setRoomAvatar(
        data: Data,
        roomId: String,
        completion: @escaping EmptyResultBlock
    ) {
        guard let room = getRoomInfo(roomId: roomId) else {
            completion(.failure)
            return
        }
        setRoomAvatar(data: data, for: room, completion: completion)
    }

    func setRoomAvatar(data: Data, for room: MXRoom, completion: @escaping EmptyResultBlock) {
        matrixService.uploadData(data: data, for: room) { link in
            guard let link = link else { completion(.failure); return }
            room.setAvatar(url: link) { [weak self] response in
                guard case .success = response else { completion(.failure); return }
                completion(.success)
                self?.objectChangePublisher.send()
            }
        }
    }

    func getRoomState(roomId: String, completion: @escaping EmptyFailureBlock<MXRoomState>) {

        let matrixRoom = matrixService.rooms.first(where: { $0.room.roomId == roomId })?.room
        guard let room = matrixRoom else { completion(.failure); return }

        room.liveTimeline { timeline in
            guard let state = timeline?.state else { completion(.failure); return }
            completion(.success(state))
        }
    }

    func getUserAvatar(
        avatarString: String,
        completion: @escaping EmptyFailureBlock<UIImage>
    ) {
        let homeServer = self.config.matrixURL
        if let url = MXURL(mxContentURI: avatarString)?.contentURL(on: homeServer) {
            self.cache.loadImage(atUrl: url) { _, image in
                guard let i = image else { return }
                completion(.success(i))
            }
        }
    }

    func avatarUrlForUser(_ userId: String, completion: @escaping (URL?) -> Void) {
        matrixService.avatarUrlForUser(userId) { result in
            completion(result)
        }
    }

    func getRoomMembers(
        roomId: String,
        completion: @escaping EmptyFailureBlock<MXRoomMembers>
    ) {
        let matrixRoom = matrixService.rooms.first(where: { $0.room.roomId == roomId })?.room
        guard let room = matrixRoom else { completion(.failure); return }

        room.liveTimeline { timeline in
            guard let state = timeline?.state else { completion(.failure); return }
            completion(.success(state.members))
        }
    }
    
    func customCheckRoomExist(_ mxId: String) -> AuraRoomData? {
        var room: AuraRoomData?
        let rooms = self.auraNoEventsRooms
        let channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self
        rooms.forEach { value in
            if value.isDirect {
                self.getRoomMembers(roomId: value.roomId,
                                    completion: { result in
                    guard case let .success(roomMembers) = result else { return }
                    let users: [ChannelParticipantsData] =  channelFactory.makeUsersData(
                        users: roomMembers.members(with: .invite) + roomMembers.members(with: .join),
                        roomPowerLevels: MXRoomPowerLevels()
                    )
                    if let user = users.first(where: { $0.matrixId != self.getUserId() }) {
                        if user.matrixId == mxId {
                            room = value
                        }
                    }
                })
            }
        }
        return room
    }

    func enableEncryptionWithAlgorithm(roomId: String) {
        matrixService.enableEncryptionWithAlgorithm(roomId: roomId) { result in
            debugPrint(result)
        }
    }

    func sendReply(
        _ event: RoomEvent,
        _ text: String,
        completion: @escaping (Result<String?, MXErrors>) -> Void
    ) {
        guard !text.isEmpty else { return }
        var rootMessage = ""
        if text.contains(">") {
            let startIndex = text.index(text.lastIndex(of: ">") ?? text.startIndex, offsetBy: 2)
            rootMessage = String(text.suffix(from: startIndex))
            let rootMessageAll = rootMessage.split(separator: "\n")
            rootMessage = String(rootMessageAll[0])
        } else {
            rootMessage = text
        }
        let customParameters: [String: Any] = [
            "m.reply_to": ReplyCustomContent(
                rootUserId: event.sender,
                rootMessage: rootMessage,
                rootEventId: event.eventId,
                rootLink: ""
            ).content
        ]
        matrixService.sendReply(
            rootMessage,
            event.roomId,
            event.eventId,
            customParameters
        ) { result in
            print("slaslsallas  \(result)")
            completion(result)
        }
    }

    func getPublicRooms(
        filter: String,
        onTapCell: @escaping (MatrixChannel) -> Void,
        completion: @escaping ([MatrixChannel]) -> Void
    ) {
        matrixService.getPublicRooms(filter: filter) { value in
            switch value {
            case .success(let success):
                guard let publicRooms = success else {
                    completion([])
                    return
                }
                let channels = publicRooms.map {
                    let room = MatrixChannel(
                        roomId: $0.roomId,
                        name: $0.name,
                        numJoinedMembers: $0.numJoinedMembers,
                        avatarUrl: $0.avatarUrl ?? "",
                        isJoined: false
                    ) { room in
                        onTapCell(room)
                    }
                    return room
                }
                completion(channels)
            case .failure(let failure):
                debugPrint("failure: \(failure)")
                completion([])
            }
        }
    }
}
