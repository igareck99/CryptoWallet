import Combine
import SwiftUI

protocol ChatViewModelProtocol: ObservableObject {

    var displayItems: [any ViewGeneratable] { get }

    var eventSubject: PassthroughSubject<ChatRoomFlow.Event, Never> { get }
}

protocol ChatEventsDelegate {
    func onContactEventTap(contactInfo: ChatContactInfo)
    func onMapEventTap(place: Place)
    func onImageTap(imageUrl: URL?)
    func onCallTap(roomId: String)
    func onDocumentTap(fileUrl: URL, fileName: String)
    func onVideoTap(url: URL)
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
    private let p2pCallsUseCase: P2PCallUseCaseProtocol

    init(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        factory: RoomEventsFactory.Type = RoomEventsFactory.self,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared
    ) {
        self.room = room
        self.coordinator = coordinator
        self.channelFactory = channelFactory
        self.factory = factory
        self.p2pCallsUseCase = p2pCallsUseCase
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
            .receive(on: DispatchQueue.main)
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
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let room = self.matrixUseCase.auraRooms.first(where: { $0.roomId == self.room.roomId })
                else {
                    return
                }
                self.displayItems = self.factory.makeEventView(
                    events: room.events,
                    delegate: self,
                    onLongPressMessage: { event in
                    self.onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    self.onRemoveReaction(reaction)
                })
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

// MARK: - ChatEventsDelegate

extension ChatViewModel: ChatEventsDelegate {
    func onContactEventTap(contactInfo: ChatContactInfo) {
        coordinator.onContactTap(contactInfo: contactInfo)
    }

    func onMapEventTap(place: Place) {
        coordinator.onMapTap(place: place)
    }

    func onImageTap(imageUrl: URL?) {
        coordinator.showImageViewer(imageUrl: imageUrl)
    }

    func onCallTap(roomId: String) {
        let contacts = [Contact]()
        self.p2pCallsUseCase.placeVoiceCall(
            roomId: roomId,
            contacts: contacts
        )
    }

    func onDocumentTap(fileUrl: URL, fileName: String) {
        coordinator.onDocumentTap(name: fileName, fileUrl: fileUrl)
    }

    func onVideoTap(url: URL) {
        coordinator.onVideoTap(url: url)
    }
}
