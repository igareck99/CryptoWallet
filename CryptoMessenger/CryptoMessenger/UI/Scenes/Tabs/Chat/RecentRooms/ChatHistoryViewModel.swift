import Combine
import UIKit

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject, ChatHistoryViewDelegate {

    weak var delegate: ChatHistorySceneDelegate?

	let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
	let sources: ChatHistorySourcesable.Type

    @Published private(set) var rooms: [AuraRoom] = []
    @Published private(set) var state: ChatHistoryFlow.ViewState = .idle
    @Published var groupAction: GroupAction?
    @Published var translateAction: TranslateAction?
    @Published var isFromCurrentUser = false
    @Published var leaveState: [String: Bool] = [:]
    @Published var roomsLastCurrent: [String: Bool] = [:]

    // MARK: - Private Properties

    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private let pushNotification: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage

    // MARK: - Lifecycle

    init(
        sources: ChatHistorySourcesable.Type = ChatHistorySources.self,
        pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared
    ) {
        self.sources = sources
        self.pushNotification = pushNotification
        self.userSettings = userSettings
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	// MARK: - ChatHistoryViewDelegate

	func rooms(with filter: String) -> [AuraRoom] {
		filter.isEmpty ? rooms : rooms.filter {
			$0.summary.displayname.lowercased().contains(filter.lowercased())
			|| $0.summary.topic?.lowercased().contains(filter.lowercased()) ?? false
		}
	}

	func markAllAsRead() {
		for room in rooms {
			room.markAllAsRead()
		}
	}

    // MARK: - Private Methods

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

    func joinRoom(_ room: AuraRoom) {
        self.matrixUseCase.joinRoom(roomId: room.room.roomId) { _ in
            self.objectWillChange.send()
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    guard let self = self else { return }
                    self.rooms = self.matrixUseCase.rooms
                    self.objectWillChange.send()
                case let .onShowRoom(room):
                    self?.delegate?.handleNextScene(.chatRoom(room))
                case let .onDeleteRoom(roomId):
                    self?.matrixUseCase.leaveRoom(roomId: roomId, completion: { _ in })
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.rooms = self.matrixUseCase.rooms
                let notJoinRoom = self.rooms.first { $0.summary.membership == .invite }
                notJoinRoom.map { room in
                    self.joinRoom(room)
                }
                DispatchQueue.main.async {
                    for room in self.rooms {
                        guard let roomId = room.room.roomId else { return }
                        self.leaveRoomAction(roomId, completion: { value in
                            self.leaveState[roomId] = value
                        })
                    }
                }
                self.allowPushNotifications()
            }
            .store(in: &subscriptions)
    }

    private func allowPushNotifications() {
        if userSettings.isRoomNotificationsEnable {
            for item in rooms {
                pushNotification.allMessages(room: item) { _ in }
            }
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
