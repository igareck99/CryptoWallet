import Combine
import SwiftUI

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject, ChatHistoryViewDelegate {

	let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
	let resources: ChatHistorySourcesable.Type

    @Published private(set) var auraRooms: [AuraRoomData] = []
    @Published private(set) var chatHistoryRooms: [ChatHistoryData] = []
    @Published var isFromCurrentUser = false
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var gloabalSearch: [any ViewGeneratable] = []
    @Published var finishView: [any ViewGeneratable] = []
    @Published var chatSections: [any ViewGeneratable] = []
    private var isStartedToJoinInvitedRooms = false
    private var _viewState: ChatHistoryViewState = .noData
    var viewState: ChatHistoryViewState {
        get {
            if isLoading {
                return .loading
            } else if !isSearching && auraRooms.isEmpty {
                return .noChats
            } else if !isSearching {
                return .chatsData
            } else if isSearching && searchText.isEmpty {
                return .emptySearch
            } else if !finishView.isEmpty {
                return .chatsFinded
            } else {
                return .noData
            }
        }
        set { 
            _viewState = newValue
        }
    }
    private var pinnedRooms: [String] = []
    @Published var searchText: String = ""

    // MARK: - Private Properties

    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private let pushService: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let factory: ChannelUsersFactoryProtocol.Type
    private let chatObjectFactory: ChatHistoryObjectFactoryProtocol
    private let keychainService: KeychainServiceProtocol = KeychainService.shared
    private let matrixObjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
    private let userDefaults: UserDefaultsService = UserDefaultsService.shared
    var coordinator: ChatsCoordinatable?
    private var roomsTimer: AnyPublisher<Date, Never>?

    // MARK: - Lifecycle

    init(
        resources: ChatHistorySourcesable.Type = ChatHistorySources.self,
        pushService: PushNotificationsServiceProtocol = PushNotificationsService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        chatObjectFactory: ChatHistoryObjectFactoryProtocol = ChatHistoryObjectFactory(),
        matrixObjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
    ) {
        self.resources = resources
        self.pushService = pushService
        self.userSettings = userSettings
        self.factory = factory
        self.chatObjectFactory = chatObjectFactory
        bindInput()
        makeAndBindTimer()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    var timerSubscription: AnyCancellable?

    // MARK: - Костыль для принудительного обнровления списка комнат
    private func makeAndBindTimer() {
//        guard toggles.isRoomsUpdateTimerAvailable else { return }
        roomsTimer = Timer
            .publish(every: 0.5, on: RunLoop.main, in: .default)
            .autoconnect()
            .prefix(
                untilOutputFrom: Just(())
                    .delay(
                        for: 60,
                        scheduler: RunLoop.main
                    )
            ).eraseToAnyPublisher()

        timerSubscription = roomsTimer?
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.getPinnedMessages()
                let rooms = self.matrixUseCase.matrixSession?.rooms
                self.matrixUseCase.objectChangePublisher.send()
                debugPrint("MATRIX DEBUG ChatHistoryViewModel roomsTimer")
                guard rooms != nil else { return }
                debugPrint("MATRIX DEBUG ChatHistoryViewModel roomsTimer.cancel()")
                self.timerSubscription?.cancel()
                self.timerSubscription = nil
                Task {
                    await self.joinToInvitedRooms()
                }
            }
    }

	// MARK: - Internal Methods

    func didTapChat(_ data: ChatHistoryData) {
        eventSubject.send(.onShowRoom(data.roomId))
    }

    func didSettingsCall(_ data: ChatHistoryData) {
        eventSubject.send(.onRoomActions(data))
    }

    func didTapFindedCell(_ data: MatrixChannel) {
        if data.isJoined {
            eventSubject.send(.onShowRoom(data.roomId))
        } else {
            joinRoom(roomId: data.roomId, openChat: true)
        }
    }

    func findJoinedRooms(with filter: String) -> [MatrixChannel] {
        if filter.isEmpty {
            return []
        }
        let data = filter.isEmpty ? chatHistoryRooms : chatHistoryRooms.filter {
            $0.roomName.lowercased().contains(filter.lowercased())
            || $0.topic.lowercased().contains(filter.lowercased())
        }
        let result = chatObjectFactory.makeChatHistoryChannels(
            dataRooms: data,
            isJoined: true,
            viewModel: self
        )
        return result
    }

    func findRooms(
        with filter: String,
        completion: @escaping ([MatrixChannel]) -> Void
    ) {
        isLoading = true
        matrixUseCase.getPublicRooms(filter: filter) { [weak self] room in
            guard let self = self else { return }
            self.joinRoom(roomId: room.roomId, openChat: true)
        } completion: { [weak self] channels in
            guard let self = self else { return }
            let result = channels.filter { item1 in
                !self.chatHistoryRooms.contains { item2 in
                    item1.roomId == item2.roomId
                }
            }.filter({ $0.name.contains(filter) })
            self.isLoading = false
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

    func joinRoom(roomId: String, openChat: Bool = false) {
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

    func onAppear() {
        self.auraRooms = self.matrixUseCase.auraNoEventsRooms
        Task {
            await joinToInvitedRooms()
        }
    }
    
    func pinRoom(_ roomId: String, _ isPinned: Bool) {
        if isPinned {
            pinnedRooms = pinnedRooms.filter({ $0 != roomId })
        } else {
            pinnedRooms.append(roomId)
        }
        self.chatHistoryRooms = self.chatObjectFactory.makeChatHistoryRooms(
            mxRooms: self.auraRooms,
            viewModel: self
        )
        matrixUseCase.objectChangePublisher.send()
        userDefaults.set(pinnedRooms, forKey: .pinnedChats)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    guard let self = self else { return }
                    self.objectWillChange.send()
                case let .onShowRoom(room):
                    guard let self = self else { return }
                    guard let mxRoom = self.matrixUseCase.getRoomInfo(roomId: room) else { return }
                    let roomFactory = RoomEventObjectFactory()
                        guard let auraRoom = matrixObjectFactory.makeAuraRooms(
                            mxRooms: [mxRoom],
                            isMakeEvents: false,
                            config: Configuration.shared,
                            eventsFactory: roomFactory,
                            matrixUseCase: self.matrixUseCase
                        ).first else { return }
                        self.coordinator?.chatRoom(room: auraRoom)
                case let .onDeleteRoom(roomId):
                    self?.matrixUseCase.leaveRoom(roomId: roomId, completion: { _ in
                        self?.matrixUseCase.objectChangePublisher.send()
                    })
                case .onCreateChat:
                    self?.coordinator?.showCreateChat()
                case let .onRoomActions(room):
                        let data = ChatActionsList(
                            isLeaveAvailable: !(room.isAdmin && room.isChannel),
                            isWatchProfileAvailable: room.isDirect,
                            isPinned: room.isPinned
                        )
                        self?.coordinator?.chatActions(
                            room: data,
                            onSelect: { value in
                        switch value {
                        case .watchProfile:
                            self?.matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] result in
                                switch result {
                                case let .success(roomMembers):
                                    guard let user = roomMembers.members.first(
                                        where: { $0.userId != self?.matrixUseCase.getUserId() }
                                    ) else { return }
                                    var displayname = ""
                                    if let name = user.displayname {
                                        displayname = name
                                    } else {
                                        if let i = user.userId.lastIndex(of: ":") {
                                            let index: Int = user.userId.distance(
                                                from: user.userId.startIndex,
                                                to: i
                                            )
                                            displayname = String(user.userId.prefix(index))
                                        }
                                    }
                                    let contact = Contact(
                                        mxId: user.userId,
                                        name: user.displayname,
                                        status: "",
                                        phone: "",
                                        type: .lastUsers,
                                        onTap: { _ in }
                                    )
                                    self?.coordinator?.dismissCurrentSheet()
                                    self?.coordinator?.friendProfile(
                                        userId: contact.mxId,
                                        roomId: room.roomId
                                    )
                                default:
                                    break
                                }
                            }
                        case .pin:
                            self?.pinRoom(room.roomId, room.isPinned)
                            self?.coordinator?.dismissCurrentSheet()
                        case .removeChat:
                            self?.coordinator?.dismissCurrentSheet()
                            self?.eventSubject.send(.onDeleteRoom(room.roomId))
                        }
                    })
                }
            }
            .store(in: &subscriptions)

        $searchText
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.isLoading = true
                    var chatSectionsCurrent: [ChatHistorySection] = []
                    let joinedRooms = findJoinedRooms(with: text)
                    if !joinedRooms.isEmpty {
                        chatSectionsCurrent.append(
                            ChatHistorySection(
                                data: .joinedChats,
                                views: joinedRooms
                            )
                        )
                    }
                    let group = DispatchGroup()
                    group.enter()
                    self.findRooms(with: text) { result in
                        self.gloabalSearch = result
                        group.leave()
                    }
                    group.notify(queue: .main) {
                        if !self.gloabalSearch.isEmpty {
                            chatSectionsCurrent.append(ChatHistorySection(data: .gloabalChats, views: self.gloabalSearch))
                        }
                        self.finishView = joinedRooms + self.gloabalSearch
                        self.chatSections = chatSectionsCurrent
                        self.isLoading = false
                    }
                } else {
                    chatSections = [ChatHistorySection(data: .emptySection, views: self.chatHistoryRooms)]
                }
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
//                debugPrint("MATRIX DEBUG ChatHistoryViewModel objectChangePublisher")
                guard let self = self else { return }
                self.updateRoomsOnPin()
                Task {
                    await self.joinToInvitedRooms()
                }
                self.chatHistoryRooms = self.chatObjectFactory.makeChatHistoryRooms(
                    mxRooms: self.auraRooms,
                    viewModel: self
                ).sorted(by: {
                    return $0.isPinned && !$1.isPinned
                })
                if !self.isSearching {
                    chatSections = [ChatHistorySection(data: .emptySection, views: self.chatHistoryRooms)]
                }
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    private func updateRoomsOnPin() {
        self.getPinnedMessages()
        self.auraRooms = self.matrixUseCase.auraNoEventsRooms.map {
            if self.pinnedRooms.contains($0.roomId) {
                let room = AuraRoomData(id: $0.id, isChannel: $0.isChannel,
                                        isAdmin: $0.isAdmin, isPinned: true, isOnline: $0.isOnline, isDirect:
                                            $0.isDirect, unreadedEvents: $0.unreadedEvents,
                                        lastMessage: $0.lastMessage, lastMessageTime: $0.lastMessageTime,
                                        roomAvatar: $0.roomAvatar, roomName: $0.roomName,
                                        numberUsers: $0.numberUsers, topic: $0.topic,
                                        roomId: $0.roomId, events: $0.events,
                                        eventCollections: $0.eventCollections, participants: $0.participants)
                return room
            }
            return $0
        }
    }

    @MainActor
    private func joinToInvitedRooms() async {
        guard isStartedToJoinInvitedRooms == false else { return }
        isStartedToJoinInvitedRooms = true
        let aurRooms = self.matrixUseCase.auraNoEventsRooms
        aurRooms.forEach { room in
            // проверка на уже присоединенную комнату
            guard let isInvited: Bool = self.matrixUseCase.isInvitedToRoom(
                roomId: room.roomId
            ), isInvited == true else {
                return
            }
            debugPrint("MATRIX DEBUG ChatHistoryViewModel matrixUseCase.joinRoom isInvited \(isInvited)")
            self.matrixUseCase.joinRoom(roomId: room.roomId) { repsonse in
                debugPrint("MATRIX DEBUG ChatHistoryViewModel matrixUseCase.joinRoom \(room.roomId)")
                debugPrint("MATRIX DEBUG ChatHistoryViewModel matrixUseCase.joinRoom \(repsonse)")
            }
        }
    }

    private func getPinnedMessages() {
        guard let result = userDefaults.array(forKey: .pinnedChats) as? [String] else { return }
        pinnedRooms = result
    }

    private func allowPushNotifications() {
        guard userSettings.isRoomNotificationsEnable else { return }
        matrixUseCase.rooms.forEach { [weak self] item in
            self?.pushService.allMessages(room: item) { result in
                debugPrint("pushService.allMessages result: \(result)")
            }
        }
    }
}
