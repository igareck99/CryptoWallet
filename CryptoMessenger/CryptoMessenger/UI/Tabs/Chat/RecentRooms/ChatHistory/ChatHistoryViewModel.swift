import Combine
import SwiftUI

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject, ChatHistoryViewDelegate {

	let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
	let resources: ChatHistorySourcesable.Type

    @Published private(set) var auraRooms: [AuraRoomData] = []
    @Published private(set) var chatHistoryRooms: [ChatHistoryData] = []
    @Published private(set) var state: ChatHistoryFlow.ViewState = .idle
    @Published var groupAction: GroupAction?
    @Published var isFromCurrentUser = false
    @Published var isLoading = false
    @Published var gloabalSearch: [any ViewGeneratable] = []
    @Published var isSearching = false
    @Published var finishView: [any ViewGeneratable] = []
    @Published var chatSections: [any ViewGeneratable] = []

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

    @Published var searchText: String = ""

    // MARK: - Private Properties

    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private let pushNotification: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let factory: ChannelUsersFactoryProtocol.Type
    private let chatObjectFactory: ChatHistoryObjectFactoryProtocol
    private let keychainService: KeychainServiceProtocol = KeychainService.shared
    private let matrixObjectFactoryProtocol = MatrixObjectFactory()
    var coordinator: ChatHistoryFlowCoordinatorProtocol?

    // MARK: - Lifecycle

    init(
        resources: ChatHistorySourcesable.Type = ChatHistorySources.self,
        pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        chatObjectFactory: ChatHistoryObjectFactoryProtocol = ChatHistoryObjectFactory()
    ) {
        self.resources = resources
        self.pushNotification = pushNotification
        self.userSettings = userSettings
        self.factory = factory
        self.chatObjectFactory = chatObjectFactory
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
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
            joinRoom(data.roomId, true)
        }
    }

    func findJoinedRooms(with filter: String) -> [MatrixChannel] {
        if filter.isEmpty {
            return []
        }
        let data = filter.isEmpty ? chatHistoryRooms : chatHistoryRooms.filter {
            $0.roomName.lowercased().contains(filter.lowercased())
            || $0.topic.lowercased().contains(filter.lowercased()) ?? false
        }
        let result = chatObjectFactory.makeChatHistoryChannels(dataRooms: data,
                                                               isJoined: true,
                                                               viewModel: self)
        return result
    }

    func findRooms(with filter: String,
                   completion: @escaping ([MatrixChannel]) -> Void) {
        isLoading = true
        self.objectWillChange.send()
        matrixUseCase.getPublicRooms(filter: filter) { room in
            self.joinRoom(room.roomId, true)
        } completion: { channels in
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

    func onAppear() {
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
                    guard let auraRoom = matrixObjectFactoryProtocol.makeAuraRooms(mxRooms: [mxRoom],
                                                                                   isMakeEvents: false,
                                                                                   config: Configuration.shared,
                                                                                   eventsFactory: roomFactory,
                                                                                   matrixUseCase: self.matrixUseCase).first else { return }
                    self.coordinator?.chatRoom(auraRoom)
                case let .onDeleteRoom(roomId):
                    self?.matrixUseCase.leaveRoom(roomId: roomId, completion: { _ in
                        self?.matrixUseCase.objectChangePublisher.send()
                    })
                case .onCreateChat:
                    self?.coordinator?.showCreateChat()
                case let .onRoomActions(room):
                    let data = ChatActionsList(isLeaveAvailable: !(room.isAdmin && room.isChannel),
                                               isWatchProfileAvailable: room.isDirect,
                                               isPinned: room.isPinned)
                    self?.coordinator?.chatActions(data, onSelect: { value in
                        switch value {
                        case .watchProfile:
                            self?.matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] result in
                                switch result {
                                case let .success(roomMembers):
                                    guard let user = roomMembers.members.first(where: {
                                        $0.userId != self?.matrixUseCase.getUserId() }) else { return }
                                    var displayname = ""
                                    if let name = user.displayname {
                                        displayname = name
                                    } else {
                                        if let i = user.userId.lastIndex(of: ":") {
                                            let index: Int = user.userId.distance(from: user.userId.startIndex,
                                                                                  to: i)
                                            displayname = String(user.userId.prefix(index))
                                        }
                                    }
                                    print("skasklaskl  \(user)")
                                    let contact = Contact(mxId: user.userId,
                                                          name: displayname,
                                                          status: "", phone: "", type: .lastUsers, onTap: { _ in
                                    })
                                    self?.coordinator?.dismissCurrentSheet()
                                    self?.coordinator?.friendProfile(contact.mxId, room.roomId)
                                default:
                                    break
                                }
                            }
                        case .pin:
                            ()
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
                    chatSections = []
                    let joinedRooms = findJoinedRooms(with: text)
                    if !joinedRooms.isEmpty {
                        chatSections.append(ChatHistorySection(data: .joinedChats,
                                                               views: joinedRooms))
                    }
                    let group = DispatchGroup()
                    group.enter()
                    self.findRooms(with: text) { result in
                        self.gloabalSearch = result
                        group.leave()
                    }
                    group.notify(queue: .main) {
                        if !self.gloabalSearch.isEmpty {
                            self.chatSections.append(ChatHistorySection(data: .gloabalChats, views: self.gloabalSearch))
                        }
                        self.finishView = joinedRooms + self.gloabalSearch
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
                guard let self = self else { return }
                self.auraRooms = self.matrixUseCase.auraNoEventsRooms
                self.chatHistoryRooms = self.chatObjectFactory.makeChatHistoryRooms(mxRooms: self.auraRooms,
                                                                                    viewModel: self)
                if !self.isSearching {
                    chatSections = [ChatHistorySection(data: .emptySection, views: self.chatHistoryRooms)]
                }
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }

    private func allowPushNotifications() {
        if userSettings.isRoomNotificationsEnable {
//            for item in rooms {
//                pushNotification.allMessages(room: item) { _ in
//                }
//            }
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
