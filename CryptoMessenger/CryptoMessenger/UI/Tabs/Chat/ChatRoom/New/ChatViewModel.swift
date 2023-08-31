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

    init(room: AuraRoomData,
         coordinator: ChatHistoryFlowCoordinatorProtocol,
         factory: RoomEventsFactory.Type = RoomEventsFactory.self) {
        self.room = room
        self.coordinator = coordinator
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
                self.displayItems = factory.makeEventView(events: room.events)
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
}
