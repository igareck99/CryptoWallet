import Combine

protocol ChatViewModelProtocol: ObservableObject {

    var displayItems: [any ViewGeneratable] { get }

    var eventSubject: PassthroughSubject<ChatRoomFlow.Event, Never> { get }
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ChatViewModelProtocol {
    @Published var displayItems = [any ViewGeneratable]()
    @Published private(set) var room: AuraRoomData
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published var eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private let factory: RoomEventsFactory.Type
    private var subscriptions = Set<AnyCancellable>()
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?

    init(room: AuraRoomData,
         coordinator: ChatHistoryFlowCoordinatorProtocol,
         channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
         factory: RoomEventsFactory.Type = RoomEventsFactory.self) {
        self.room = room
        self.coordinator = coordinator
        self.channelFactory = channelFactory
        self.factory = factory
        // displayItems = factory.mockItems
        bindInput()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func bindInput() {
        eventSubject
            .sink { value in
                switch value {
                case .onAppear:
                    self.matrixUseCase.getRoomState(roomId: self.room.roomId) { [weak self] result in
                        guard let self = self else { return }
                        guard case let .success(state) = result else { return }
                        self.roomPowerLevels = state.powerLevels
                        self.matrixUseCase.objectChangePublisher.send()
                        self.objectWillChange.send()
                    }
                    self.matrixUseCase.objectChangePublisher.send()
                    self.objectWillChange.send()
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let room = self.matrixUseCase.auraRooms.first(where: { $0.roomId == self.room.roomId })
                else {
                    return
                }
                self.displayItems = self.factory.makeEventView(events: room.events, onLongPressMessage: { event in
                    self.onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    self.onRemoveReaction(reaction)
                })
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    private func onLongPressMessage(_ event: RoomEvent) {
        let role = channelFactory.detectUserRole(userId: event.sender,
                                                 roomPowerLevels: roomPowerLevels)
        coordinator.messageReactions(event.isFromCurrentUser,
                                     room.isChannel,
                                     role, { action in
            debugPrint("Message Action  \(action)")
        }, { reaction in
            self.coordinator.dismissCurrentSheet()
            self.matrixUseCase.react(eventId: event.eventId,
                                     roomId: self.room.roomId,
                                     emoji: reaction)
            self.matrixUseCase.objectChangePublisher.send()
            self.objectWillChange.send()
            debugPrint("Reaction To Send  \(reaction)")
        })
    }
    
    private func onRemoveReaction(_ event: ReactionNewEvent) {
        guard let userId = event.sendersIds.first(where: { $0 == matrixUseCase.getUserId() }) else { return }
        matrixUseCase.removeReaction(roomId: room.roomId,
                                     text: "",
                                     eventId: event.eventId) { _ in
            self.matrixUseCase.objectChangePublisher.send()
            self.objectWillChange.send()
        }
    }
}
