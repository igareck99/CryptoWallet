import Combine
import Foundation
import MatrixSDK

final class MatrixUseCase {

    static let shared = MatrixUseCase()

    var objectChangePublisher: ObservableObjectPublisher {
        matrixService.objectChangePublisher
    }

    var loginStatePublisher: Published<MatrixState>.Publisher {
        matrixService.loginStatePublisher
    }

    var devicesPublisher: Published<[MXDevice]>.Publisher {
        matrixService.devicesPublisher
    }

    var roomStatePublisher: Published<MXRoomState>.Publisher {
        matrixService.roomStatePublisher
    }

    var matrixSession: MXSession? {
        matrixService.matrixSession
    }

    var isRoomsCheckReady: Bool {
        debugPrint("MATRIX DEBUG MatrixUseCase isRoomsCheckReady \(matrixService.matrixSession?.rooms)")
        return matrixService.matrixSession?.rooms != nil
    }

    var rooms = [AuraRoomData]()
    let matrixService: MatrixServiceProtocol
    let config: ConfigType
    let cache: ImageCacheServiceProtocol
    let jitsiFactory: JitsiWidgetFactoryProtocol.Type
    let keychainService: KeychainServiceProtocol
    let userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage
    let channelFactory: ChannelUsersFactoryProtocol.Type
    let matrixobjectFactory: MatrixObjectFactoryProtocol
	private var subscriptions = Set<AnyCancellable>()
	private let toggles: MatrixUseCaseTogglesProtocol
    private let chatObjectFactory: ChatHistoryObjectFactoryProtocol
    private let eventsFactory: RoomEventObjectFactoryProtocol
    var listenReference: MXSessionEventListener?

    init(
        matrixService: MatrixServiceProtocol = MatrixService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage = UserDefaultsService.shared,
        toggles: MatrixUseCaseTogglesProtocol = MatrixUseCaseToggles(),
        config: ConfigType = Configuration.shared,
        cache: ImageCacheServiceProtocol = ImageCacheService.shared,
        jitsiFactory: JitsiWidgetFactoryProtocol.Type = JitsiWidgetFactory.self,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        chatObjectFactory: ChatHistoryObjectFactoryProtocol = ChatHistoryObjectFactory(),
        matrixobjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory(),
        eventsFactory: RoomEventObjectFactoryProtocol = RoomEventObjectFactory()
    ) {
        self.matrixService = matrixService
        self.keychainService = keychainService
        self.userSettings = userSettings
        self.toggles = toggles
        self.config = config
        self.cache = cache
        self.jitsiFactory = jitsiFactory
        self.channelFactory = channelFactory
        self.chatObjectFactory = chatObjectFactory
        self.matrixobjectFactory = matrixobjectFactory
        self.eventsFactory = eventsFactory
        observeLoginState()
        observeSessionToken()
    }

    func subscribeToEvents() {
        listenReference = matrixSession?.listenToEvents { [weak self] event, direction, roomState in
            debugPrint("MATRIX DEBUG MatrixUseCase listenToEvents")
            guard let self = self else { return }
            // Update the rooms number, etc...
            self.checkRoomsUpdate(mxRooms: self.matrixSession?.rooms)
            DispatchQueue.main.async {
                self.objectChangePublisher.send()
            }
        } as? MXSessionEventListener
    }

    private func checkRoomsUpdate(mxRooms: [MXRoom]?) {
        guard let updatedRooms = mxRooms, rooms.count != updatedRooms.count else {
            return
        }

        let existingRoomsIds: Set<String> = rooms.reduce(into: Set<String>()) {
            $0.insert($1.roomId)
        }

        let updatedRoomsIds: Set<String> = updatedRooms.reduce(into: Set<String>()) {
            $0.insert($1.roomId)
        }

        // Detect removed rooms
        let removedRoomsIds: Set<String> = existingRoomsIds.subtracting(updatedRoomsIds)
        removedRoomsIds.forEach { removedRoomId in
            guard let roomToRemove: (Int, AuraRoomData) = rooms.enumerated()
                .first(where: { room in room.1.roomId == removedRoomId }) else {
                    return
                }
            rooms.remove(at: roomToRemove.0)
        }

        // Detect new rooms
        let newRoomsIds: Set<String> = updatedRoomsIds.subtracting(existingRoomsIds)
        let newRooms: [MXRoom] = newRoomsIds.compactMap {
            guard let newRoom: MXRoom = matrixSession?.room(withRoomId: $0) else {
                return nil
            }
            return newRoom
        }

        let newAuraRooms: [AuraRoomData] = matrixobjectFactory
            .makeAuraRooms(
                mxRooms: newRooms,
                isMakeEvents: true,
                config: config,
                eventsFactory: eventsFactory,
                matrixUseCase: self
            )
        debugPrint("MATRIX DEBUG MatrixUseCase checkRoomsUpdate")
        self.rooms.append(contentsOf: newAuraRooms)
        self.objectChangePublisher.send()
    }
}

// MARK: - MatrixUseCaseProtocol

extension MatrixUseCase: MatrixUseCaseProtocol {

    // MARK: - Sync

    func serverSyncWithServerTimeout() {
        // TODO: Trigger storage sync with server
        matrixService.matrixSession?.backgroundSync { response in
            debugPrint("matrixService.matrixSession?.backgroundSync: \(response)")
        }
    }
}
