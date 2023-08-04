import Combine
import UIKit

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject, ChatHistoryViewDelegate {

	let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
	let sources: ChatHistorySourcesable.Type

    @Published private(set) var rooms: [AuraRoom] = []
    @Published private(set) var chatHistoryRooms: [ChatHistoryData] = []
    @Published private(set) var state: ChatHistoryFlow.ViewState = .idle
    @Published var groupAction: GroupAction?
    @Published var isFromCurrentUser = false
    @Published var leaveState: [String: Bool] = [:]
    @Published var roomsLastCurrent: [String: Bool] = [:]
    @Published var isLoading = false

    // MARK: - Private Properties

    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private let pushNotification: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let factory: ChannelUsersFactoryProtocol.Type
    private let keychainService: KeychainServiceProtocol = KeychainService.shared
    var coordinator: ChatHistoryFlowCoordinatorProtocol?

    // MARK: - Lifecycle

    init(
        sources: ChatHistorySourcesable.Type = ChatHistorySources.self,
        pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self
    ) {
        self.sources = sources
        self.pushNotification = pushNotification
        self.userSettings = userSettings
        self.factory = factory
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	// MARK: - Internal Methods

	func rooms(with filter: String) -> [ChatHistoryData] {
		let result = filter.isEmpty ? chatHistoryRooms : chatHistoryRooms.filter {
			$0.roomName.lowercased().contains(filter.lowercased())
            || $0.topic.lowercased().contains(filter.lowercased()) ?? false
		}
        return result
	}

    func findRooms(with filter: String,
                   completion: @escaping ([MatrixChannel]) -> Void) {
        isLoading = true
        self.objectWillChange.send()
        var value: [MatrixChannel] = []
        matrixUseCase.getPublicRooms(filter: filter) { channels in
            let result = channels.filter { item1 in !self.chatHistoryRooms.contains { item2 in item1.roomId == item2.roomId } }
            self.isLoading = false
            self.objectWillChange.send()
            completion(result)
        }
    }

	func markAllAsRead() {
		for room in chatHistoryRooms {
            matrixUseCase.markAllAsRead(roomId: room.roomId)
		}
	}

    func fromCurrentSender(room: AuraRoom) -> Bool {
        let event = room.events().renderableEvents.filter({ !$0.eventId.contains("kMXEventLocalId") })
        let lastEvent = event.first
        guard let str = lastEvent?.eventId else { return false }
        return matrixUseCase.fromCurrentSender(str)
    }

    func leaveRoomAction(_ roomId: String, completion: @escaping (Bool) -> Void) {
        matrixUseCase.getRoomState(roomId: roomId) { result in
            guard case let .success(state) = result else { return }
            if state.powerLevels == nil {
                completion(true)
            } else {
                let currentUserPowerLevel = state.powerLevels.powerLevelOfUser(withUserID: self.matrixUseCase.getUserId())
                completion(state.powerLevels.eventsDefault == 50)
            }
        }
    }

    func joinRoom(_ roomId: String, _ openChat: Bool = false) {
        self.matrixUseCase.joinRoom(roomId: roomId) { result in
            switch result {
            case .success(let room):
                let auraRoom = AuraRoom(room)
                if openChat {
                    self.eventSubject.send(.onShowRoom(auraRoom.room.roomId))
                }
            case .failure(_):
                break
            }
            self.objectWillChange.send()
        }
    }

    func configureCalls() {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return
        }

        StatusBarCallUseCase.shared.configure(window: window)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    guard let self = self else { return }
                    self.configureCalls()
                    self.rooms = self.matrixUseCase.rooms
                    self.chatHistoryRooms = self.matrixUseCase.chatHistoryRooms
                    self.objectWillChange.send()
                case let .onShowRoom(room):
                    guard let coordinator = self?.coordinator else { return }
                    guard let mxRoom = self?.matrixUseCase.getRoomInfo(roomId: room) else { return }
                    self?.coordinator?.firstAction(AuraRoom(mxRoom), coordinator: coordinator)
                case let .onDeleteRoom(roomId):
                    self?.matrixUseCase.leaveRoom(roomId: roomId, completion: { _ in })
                case let .onCreateChat(chatData):
                    self?.coordinator?.showCreateChat(chatData)
                case let .onRoomActions(roomId):
                    self?.coordinator?.chatActions(roomId)
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.rooms = self.matrixUseCase.rooms
                self.chatHistoryRooms = self.matrixUseCase.chatHistoryRooms
                let notJoinRoom = self.rooms.first { $0.summary.membership == .invite }
                notJoinRoom.map { room in
                    self.joinRoom(room.room.roomId)
                }
                DispatchQueue.main.async {
                    for room in self.rooms {
                        guard let roomId = room.room.roomId else { return }
                        self.leaveRoomAction(roomId, completion: { value in
                            self.leaveState[roomId] = value
                        })
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func allowPushNotifications() {
        if userSettings.isRoomNotificationsEnable {
            for item in rooms {
                pushNotification.allMessages(room: item) { _ in
                }
            }
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
