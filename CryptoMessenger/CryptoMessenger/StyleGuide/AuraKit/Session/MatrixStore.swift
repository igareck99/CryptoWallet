import Combine
import Foundation
import KeychainAccess
import MatrixSDK

// MARK: - MatrixState

enum MatrixState {

    // MARK: - Types

    case loggedOut
    case authenticating
    case failure(Error)
    case loggedIn(userId: String)
}

// MARK: - MatrixStore

final class MatrixStore: ObservableObject {

    // MARK: - Internal Properties

    @Published var loginState: MatrixState = .loggedOut

    var rooms: [AuraRoom] {
        guard let session = session else { return [] }

        let rooms = session.rooms
            .map { makeRoom(from: $0) }
            .sorted { $0.summary.lastMessageDate > $1.summary.lastMessageDate }

        updateUserDefaults(with: rooms)
        return rooms
    }

    // MARK: - Private Properties

    private var client: MXRestClient?
    private var session: MXSession?
    private var fileStore: MXFileStore?
    private var credentials: MXCredentials?
    private var uploader: MXMediaLoader?
    private let keychain = Keychain(service: "chat.aura.credentials")
    private var listenReference: Any?
    private var roomCache: [ObjectIdentifier: AuraRoom] = [:]
    private var listenReferenceRoom: Any?

    // MARK: - Lifecycle

    init() {
        if CommandLine.arguments.contains("-clear-stored-credentials") {
            print("🗑 cleared stored credentials from keychain")
            MXCredentials
                .from(keychain)?
                .clear(from: keychain)
        }

        MatrixConfiguration.setupMatrixSDKSettings()

        if let credentials = MXCredentials.from(keychain) {
            self.loginState = .authenticating
            self.credentials = credentials
            self.sync { result in
                switch result {
                case .failure(let error):
                    print("Error on starting session with saved credentials: \(error)")
                    self.loginState = .failure(error)
                case let .success(state):
                    self.loginState = state
                    self.session?.crypto.warnOnUnknowDevices = false
                    self.startListeningForRoomEvents()
                }
            }
        }
    }

    deinit {
        session?.removeListener(listenReference)
    }

    // MARK: - Session

    func login(username: String, password: String, homeServer: URL) {
        loginState = .authenticating

        client = MXRestClient(homeServer: homeServer, unrecognizedCertificateHandler: nil)
        client?.login(username: username, password: password) { response in
            switch response {
            case .failure(let error):
                print("Error on starting session with new credentials: \(error)")
                self.loginState = .failure(error)
            case let .success(credentials):
                self.credentials = credentials
                credentials.save(to: self.keychain)
                print("Error on starting session with new credentials:")
                self.sync { result in
                    switch result {
                    case .failure(let error):
                        self.loginState = .failure(error)
                    case .success(let state):
                        self.loginState = state
                        self.session?.crypto.warnOnUnknowDevices = false
                        self.startListeningForRoomEvents()
                    }
                }
            }
        }
    }

    func logout(completion: @escaping (Result<MatrixState, Error>) -> Void) {
        credentials?.clear(from: keychain)
        session?.logout { response in
            switch response {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                self.fileStore?.deleteAllData()
                completion(.success(.loggedOut))
            }
        }
    }

    func logout() {
        client?.devices { [weak self] response in
            switch response {
            case let .success(devices):
                let group = DispatchGroup()
                devices.forEach {
                    group.enter()
                    self?.removeDevice($0.deviceId) { group.leave() }
                }
                group.notify(queue: .main) {
                    self?.loginState = .loggedOut
                    self?.logout { result in
                        switch result {
                        case .failure:
                            self?.loginState = .loggedOut
                        case .success(let state):
                            self?.loginState = state
                        }
                    }
                }
            default:
                break
            }
        }
    }

    private func removeDevice(_ deviceId: String, completion: @escaping VoidBlock) {
        client?.getSession(toDeleteDevice: deviceId) { res in
            switch res {
            case .success:
                self.client?.deleteDevice(deviceId, authParameters: [:]) { response in
                    switch response {
                    case .success:
                        print("Delete device with ID: " + deviceId)
                    default:
                        break
                    }
                    completion()
                }
            case .failure:
                completion()
            }
        }
    }

    private func sync(completion: @escaping (Result<MatrixState, Error>) -> Void) {
        guard let credentials = credentials else { return }

        let client = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)
        let session = MXSession(matrixRestClient: client)
        let fileStore = MXFileStore()

        self.client = client
        self.session = session
        self.fileStore = fileStore
        self.uploader = MXMediaLoader(forUploadWithMatrixSession: session, initialRange: 0, andRange: 1)

        session?.setStore(fileStore) { response in
            switch response {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                self.session?.start { response in
                    switch response {
                    case let .failure(error):
                        completion(.failure(error))
                    case .success:
                        let userId = credentials.userId!
                        completion(.success(.loggedIn(userId: userId)))
                    }
                }
            }
        }
    }

    // MARK: - Rooms

    func startListeningForRoomEvents() {
        listenReference = session?.listenToEvents { event, direction, roomState in
            let affectedRooms = self.rooms.filter { $0.summary.roomId == event.roomId }
            affectedRooms.forEach {
                $0.add(event: event, direction: direction, roomState: roomState as? MXRoomState)
            }
            self.objectWillChange.send()
        }
    }

    func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void) {
        session?.createRoom(parameters: parameters) { [weak self] response in
            completion(response)
            self?.objectWillChange.send()
        }
    }

    func setRoomAvatar(data: Data, for room: MXRoom, completion: @escaping VoidBlock) {
        uploader?.uploadData(data, filename: nil, mimeType: "image/jpeg", success: { [weak self] link in
            guard let link = link, let url = URL(string: link) else { return }
            room.setAvatar(url: url) { _ in
                completion()
                self?.objectWillChange.send()
            }
        }, failure: { error in
            if let error = error {
                print(error)
            }
            completion()
        })
    }

    func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void) {
        session?.leaveRoom(roomId, completion: completion)
    }

    func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void) {
        session?.joinRoom(roomId, completion: completion)
    }

    private func makeRoom(from mxRoom: MXRoom) -> AuraRoom {
        let room = AuraRoom(mxRoom)
        if mxRoom.isDirect {
            room.isOnline = currentlyActive(mxRoom.directUserId)
        }
        roomCache[mxRoom.id] = room
        return room
    }

    // MARK: - Users

    func currentlyActive(_ userId: String) -> Bool {
        session?.user(withUserId: userId)?.currentlyActive ?? false
    }

    func fromCurrentSender(_ userId: String) -> Bool {
        credentials?.userId == userId
        //session?.crypto.backup
        //бэкапы ключей чатов
    }

    func getUser(_ id: String) -> MXUser? { session?.user(withUserId: id) }
    func getUserId() -> String { session?.myUser?.userId ?? "" }
    func getDisplayName() -> String { session?.myUser?.displayname ?? "" }
    func getStatus() -> String { session?.myUser?.statusMsg ?? "" }

    func setDisplayName(_ displayName: String, completion: @escaping VoidBlock) {
        session?.myUser.setDisplayName(displayName, success: completion) { error in
            if let error = error {
                print(error)
            }
            self.objectWillChange.send()
        }
    }

    func setStatus(_ status: String, completion: @escaping VoidBlock) {
        session?.myUser.setPresence(.init(rawValue: 2), andStatusMessage: status, success: completion) { error in
            if let error = error {
                print(error)
            }
            self.objectWillChange.send()
        }
    }

    func setUserAvatarUrl(_ data: Data, completion: @escaping VoidBlock) {
        let uploader = MXMediaLoader(forUploadWithMatrixSession: session, initialRange: 0, andRange: 1)
        uploader?.uploadData(Data(), filename: nil, mimeType: "image/jpeg", success: { [weak self] link in
            self?.session?.myUser.setAvatarUrl(link, success: completion) { error in
                if let error = error {
                    print(error)
                }
                self?.objectWillChange.send()
            }

        }, failure: { _ in

        })
    }

    func allUsers() -> [MXUser] {
        session?.users().filter { $0.userId != session?.myUserId } ?? []
    }

    func searchUser(_ id: String, completion: @escaping GenericBlock<String?>) {
//        client?.searchUsers(id, limit: 1000, success: { [weak self] response in
//            let users = response?.results?.filter { $0.userId != self?.session?.myUserId } ?? []
//            completion(users)
//        }, failure: { error in
//            if let error = error {
//                print(error)
//            }
//            completion([])
//        })
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

    private func updateUserDefaults(with rooms: [AuraRoom]) {
        let roomItems = rooms.map { RoomItem(room: $0.room) }
        do {
            let data = try JSONEncoder().encode(roomItems)
            UserDefaults.group.set(data, forKey: "roomList")
        } catch {
            print("An error occurred: \(error)")
        }
    }

    // MARK: - Pagination

    func paginate(room: AuraRoom, event: MXEvent) {
        let timeline = room.room.timeline(onEvent: event.eventId)
        listenReferenceRoom = timeline?.listenToEvents { event, direction, roomState in
            if direction == .backwards {
                room.add(event: event, direction: direction, roomState: roomState)
            }
            self.objectWillChange.send()
        }
        timeline?.resetPaginationAroundInitialEvent(withLimit: 1000) { _ in
            self.objectWillChange.send()
        }
    }

}
