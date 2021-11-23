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

    // MARK: - Private Properties

    private var client: MXRestClient?
    private var session: MXSession?
    private var fileStore: MXFileStore?
    private var credentials: MXCredentials?
    private let keychain = Keychain(service: "chat.aura.credentials")

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

    // MARK: - Login & Sync

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
        logout { result in
            switch result {
            case .failure:
                self.loginState = .loggedOut
            case .success(let state):
                self.loginState = state
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

    var listenReference: Any?

    func startListeningForRoomEvents() {
        listenReference = session?.listenToEvents { event, direction, roomState in
            let affectedRooms = self.rooms.filter { $0.summary.roomId == event.roomId }
            affectedRooms.forEach {
                $0.add(event: event, direction: direction, roomState: roomState as? MXRoomState)
            }
            self.objectWillChange.send()
        }
    }

    func currentlyActive(_ userId: String) -> Bool {
        session?.user(withUserId: userId).currentlyActive ?? false
    }

    func fromCurrentSender(_ userId: String) -> Bool {
        credentials?.userId == userId
        //session?.crypto.backup
        //бэкапы ключей чатов
    }

    private var roomCache: [ObjectIdentifier: AuraRoom] = [:]

    private func makeRoom(from mxRoom: MXRoom) -> AuraRoom {
        let room = AuraRoom(mxRoom)
        if mxRoom.isDirect {
            room.isOnline = currentlyActive(mxRoom.directUserId)
        }
        roomCache[mxRoom.id] = room
        return room
    }

    var rooms: [AuraRoom] {
        guard let session = session else { return [] }

        let rooms = session.rooms
            .map { makeRoom(from: $0) }
            .sorted { $0.summary.lastMessageDate > $1.summary.lastMessageDate }

        updateUserDefaults(with: rooms)
        return rooms
    }

    private func updateUserDefaults(with rooms: [AuraRoom]) {
        let roomItems = rooms.map { RoomItem(room: $0.room) }
        do {
            let data = try JSONEncoder().encode(roomItems)
            UserDefaults.group.set(data, forKey: "roomList")
        } catch {
            print("An error occured: \(error)")
        }
    }

    var listenReferenceRoom: Any?

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

    func createRoom(parameters: MXRoomCreationParameters, completion: @escaping ( MXResponse<MXRoom>) -> Void) {
        let room = rooms.first {
            $0.isDirect && $0.room.directUserId == parameters.inviteArray?.first
        }
        if room == nil {
            session?.createRoom(parameters: parameters, completion: completion)
        }
    }

    func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void) {
        session?.leaveRoom(roomId, completion: completion)
    }

    func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void) {
        session?.joinRoom(roomId, completion: completion)
    }
}
