import Combine
import SwiftUI

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ChatViewModelProtocol {
    @Published var saveData = false
    @Published var isAvatarLoading = false
    @Published var roomAvatarUrl: URL?
    @Published var displayItems = [any ViewGeneratable]()
    @Published var chatData = ChatData()
    @Published private(set) var room: AuraRoomData
    @Published var participants: [ChannelParticipantsData] = []
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published var eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    var p2pVideoCallPublisher = ObservableObjectPublisher()
    var groupCallPublisher = ObservableObjectPublisher()
    var p2pVoiceCallPublisher = ObservableObjectPublisher()
    private let factory: RoomEventsFactory.Type
    private var subscriptions = Set<AnyCancellable>()
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    private let p2pCallsUseCase: P2PCallUseCaseProtocol
    private let groupCallsUseCase: GroupCallsUseCaseProtocol
    private let availabilityFacade: ChatRoomTogglesFacadeProtocol
    private let config: ConfigType
    let resources: ChatRoomSourcesable.Type
    var roomName: String { room.roomName }
    var isDirect: Bool { room.isDirect }
    var isOnline: Bool { room.isOnline }
    var userHasAccessToMessage = true
    var isChannel = false

    var isGroupCall: Bool {
        room.isDirect == false && availabilityFacade.isGroupCallsAvailable && !self.isChannel
    }

    var isVoiceCallAvailable: Bool {
        availabilityFacade.isCallAvailable && room.isDirect && !self.isChannel
    }

    var isVideoCallAvailable: Bool {
        availabilityFacade.isVideoCallAvailable && room.isDirect && !self.isChannel
    }

    @Published var isVoiceCallAvailablility = false
    @Published var isVideoCallAvailablility = false
    @Published var isChatGroupMenuAvailable = false
    @Published var isChatDirectMenuAvailable = false

    var roomUsersCount: Int {
        room.numberUsers
    }

    init(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        factory: RoomEventsFactory.Type = RoomEventsFactory.self,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared,
        groupCallsUseCase: GroupCallsUseCaseProtocol,
        config: ConfigType = Configuration.shared,
        resources: ChatRoomSourcesable.Type = ChatRoomResources.self,
        availabilityFacade: ChatRoomTogglesFacadeProtocol = ChatRoomViewModelAssembly.build()
    ) {
        self.room = room
        self.coordinator = coordinator
        self.channelFactory = channelFactory
        self.factory = factory
        self.p2pCallsUseCase = p2pCallsUseCase
        self.groupCallsUseCase = groupCallsUseCase
        self.config = config
        self.resources = resources
        self.availabilityFacade = availabilityFacade
        bindInput()
        updateData()
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

    func onGroupCallTap(eventId: String) {
        self.groupCallsUseCase.joinGroupCallInRoom(eventId: eventId, roomId: self.room.roomId)
        self.updateToggles()
    }
}
