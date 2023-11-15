import Combine
import SwiftUI
import MatrixSDK

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ChatViewModelProtocol {

    @Published var isAvatarLoading = false
    @Published var roomAvatarUrl: URL?
    @Published var chatData = ChatData()
    @Published var participants: [ChannelParticipantsData] = []
    @Published var displayItems = [any ViewGeneratable]()
    var itemsFromMatrix = [any ViewGeneratable]()
    @Published var inputText = ""
    @Published var scroolString = UUID()
    var scrollId: Published<UUID> { _scroolString }
    var scrollIdPublisher: Published<UUID>.Publisher { $scroolString }
    @Published var activeEditMessage: RoomEvent?
    @Published var quickAction: QuickActionCurrentUser?
    @Published var room: AuraRoomData
    @Published var replyDescriptionText = ""
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    let mediaService = MediaService()
    let matrixobjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Published var eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    @Published var sendingEvents: [RoomEvent] = []
    @Published var sendingEventsView: [any ViewGeneratable] = []

    // MARK: - Private Properties

    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private let factory: RoomEventsFactory.Type
    private var subscriptions = Set<AnyCancellable>()
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    let p2pCallsUseCase: P2PCallUseCaseProtocol
    let groupCallsUseCase: GroupCallsUseCaseProtocol
    private let config: ConfigType
    private let availabilityFacade: ChatRoomTogglesFacadeProtocol
    @Injectable private var apiClient: APIClientManager

    // MARK: - To replace
    @Published var location = Place(name: "", latitude: 0, longitude: 0)
    @Published var isSendLocation = false
    var resources: ChatRoomSourcesable.Type
    var p2pVideoCallPublisher = ObservableObjectPublisher()
    var groupCallPublisher = ObservableObjectPublisher()
    var p2pVoiceCallPublisher = ObservableObjectPublisher()
    var roomName: String { room.roomName }
    var isDirect: Bool { room.isDirect }
    var isOnline: Bool { room.isOnline }
    @Published var userHasAccessToMessage = true
    @Published var isChannel = false

    private var scrollProxy: ScrollViewProxy?

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
        self.config = config
        self.groupCallsUseCase = groupCallsUseCase
        self.resources = resources
        self.availabilityFacade = availabilityFacade
        bindInput()
        updateData()
        joinRoom(roomId: room.roomId)
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func updateToggles() {
        DispatchQueue.main.async {
            let isP2PChat = self.room.isDirect == true && self.roomUsersCount == 2
            let call = self.matrixUseCase.matrixSession?.callManager.call(inRoom: self.room.roomId)
            let isCallInProgress = self.p2pCallsUseCase.isActiveCallExist && (call != nil)
            let isCallAvailable = self.availabilityFacade.isCallAvailable
            self.isVoiceCallAvailablility = isCallAvailable && isP2PChat && !isCallInProgress
            self.isChatDirectMenuAvailable = self.availabilityFacade.isChatDirectMenuAvailable
            self.isChatGroupMenuAvailable = self.availabilityFacade.isChatGroupMenuAvailable
            let isVideoCallAvailable = self.availabilityFacade.isVideoCallAvailable
            self.isVideoCallAvailablility = isVideoCallAvailable && isP2PChat && !isCallInProgress
//            self.isReactionsAvailable = availabilityFacade.isReactionsAvailable
//            self.isVideoMessageAvailable = availabilityFacade.isVideoMessageAvailable
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            debugPrint("scrollToBottom scrollProxy: \(self.scrollProxy)")
            debugPrint("scrollToBottom last: \(self.displayItems.last)")
            if let last = self.displayItems.last {
                debugPrint("scrollToBottom last.id: \(last.id)")
                self.scrollProxy?.scrollTo(last.id, anchor: .bottom)
            }
        }
    }

    private func bindInput() {
        eventSubject
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink {[weak self] value in
                guard let self = self else { return }
                switch value {
                case let .onAppear(proxy):
                        self.scrollProxy = proxy
//                        scrollToBottom()
                    self.matrixUseCase.getRoomState(roomId: self.room.roomId) { [weak self] result in
                        guard let self = self else { return }
                        guard case let .success(state) = result,
                              let pLevels = state.powerLevels else { return }
                        debugPrint("self?.isChannel: pLevels.eventsDefault == 50 \(self.isChannel)")
                    }
                    self.loadUsers()
                    guard let mxRoom = self.matrixUseCase.getRoomInfo(roomId: self.room.roomId) else { return }
                    guard let auraRoom = self.matrixobjectFactory
                        .makeAuraRooms(mxRooms: [mxRoom],
                                       isMakeEvents: false,
                                       config: self.config,
                                       eventsFactory: RoomEventObjectFactory(),
                                       matrixUseCase: self.matrixUseCase).first else { return }
                    DispatchQueue.main.async {
                        self.updateToggles()
                        self.room = auraRoom
                        self.roomAvatarUrl = auraRoom.roomAvatar
                    }
                    self.matrixUseCase.markAllAsRead(roomId: self.room.roomId)
                    self.matrixUseCase.objectChangePublisher.send()
                    self.getRoomPowerLevels()
                    self.updateData()
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let currentRoom = self.matrixUseCase.auraRooms.first(where: { $0.roomId == self.room.roomId })
                else {
                    return
                }
                self.itemsFromMatrix = self.factory.makeEventView(
                    events: currentRoom.events,
                    existingEvents: self.room.events,
                    delegate: self,
                    onLongPressMessage: { event in
                    self.onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    self.onRemoveReaction(reaction)
                }, onTapNotSendedMessage: { event in
                    self.onTapNotSendedMessage(event)
                }, onSwipeReply: { value in
                    self.activeEditMessage = value
                    self.quickAction = .reply
                    self.replyDescriptionText = self.makeReplyDescription(self.activeEditMessage)
                })
                self.room = currentRoom
                DispatchQueue.main.async {
                    self.displayItems = self.itemsFromMatrix
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        guard !self.itemsFromMatrix.isEmpty else { return }
                        self.scroolString = self.displayItems.last?.id ?? UUID()
                    }
                    self.matrixUseCase.markAllAsRead(roomId: self.room.roomId)
                    self.objectWillChange.send()
                }
            }
            .store(in: &subscriptions)
        $sendingEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.sendingEventsView = self.factory.makeEventView(
                    events: value,
                    existingEvents: self.room.events,
                    delegate: self,
                    onLongPressMessage: { _ in },
                    onReactionTap: { _ in },
                    onTapNotSendedMessage: { [weak self] event in
                        self?.onTapNotSendedMessage(event)
                    }, onSwipeReply: { _ in
                    }
                )
            }
            .store(in: &subscriptions)

        $sendingEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.sendingEventsView = self.factory.makeEventView(
                    events: value,
                    existingEvents: self.room.events,
                    delegate: self,
                    onLongPressMessage: { _ in },
                    onReactionTap: { _ in },
                    onTapNotSendedMessage: { [weak self] event in
                        self?.onTapNotSendedMessage(event)
                    }, onSwipeReply: { _ in
                    }
                )
            }
            .store(in: &subscriptions)

        p2pVideoCallPublisher
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                debugPrint("Place_Call: p2pVideoCallPublisher")
                guard let self = self else { return }

                if self.isGroupCall {
                    self.groupCallsUseCase.placeGroupCallInRoom(roomId: self.room.roomId)
                    return
                }
                self.p2pCallsUseCase.placeVideoCall(
                    roomId: self.room.roomId,
                    contacts: self.chatData.contacts
                )
                self.updateToggles()
            }.store(in: &subscriptions)

        p2pVoiceCallPublisher
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                debugPrint("Place_Call: p2pVoiceCallPublisher")
                // TODO: Handle failure case
                guard let self = self else { return }
                let roomId = self.room.roomId
                self.p2pCallsUseCase.placeVoiceCall(
                    roomId: roomId,
                    contacts: self.chatData.contacts
                )
                self.updateToggles()
            }.store(in: &subscriptions)

        groupCallPublisher
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                debugPrint("Place_Call: groupCallPublisher")
                guard let self = self else { return }
                self.groupCallsUseCase.placeGroupCallInRoom(roomId: self.room.roomId)
                self.updateToggles()
            }.store(in: &subscriptions)
    }

    func joinRoom(roomId: String) {
        self.matrixUseCase.joinRoom(roomId: roomId) { _ in
            guard let newRoom = self.matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {
                return
            }
            debugPrint("joinRoom(roomId: \(roomId)")
            debugPrint("joinRoom(roomId")
        }
    }

    func updateData() {
        getRoomPowerLevels()
        getChatData()
        getRoomAvatarUrl()
        updateToggles()
    }

    func getChatData() {
        matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] response in
            guard let self = self,
                  case let .success(members) = response else { return }

            let users: [ChannelParticipantsData] = self.channelFactory.makeUsersData(
                users: members.members,
                roomPowerLevels: self.roomPowerLevels
            )

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.participants = users
                self.room.participants = users
                self.room.numberUsers = participants.count
            }

            let contacts: [Contact] = members.members.map {
                var contact = Contact(
                    mxId: $0.userId ?? "",
                    avatar: nil,
                    name: $0.displayname ?? "",
                    status: "Привет, теперь я в Aura",
                    phone: "",
                    type: .lastUsers, onTap: { _ in
                    }
                )
                if let avatar = $0.avatarUrl {
                    contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: self.config.matrixURL)
                }
                return contact
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.chatData.contacts = contacts
            }

            self.matrixUseCase.getRoomState(roomId: self.room.roomId) { [weak self] response in
                guard case let .success(roomState) = response else { return }
                let ids = roomState.powerLevels?.users.keys
                    .map { $0 as? String }
                    .compactMap { $0 } ?? []
                self?.chatData.admins = contacts.filter { contact in ids.contains(contact.mxId) }
                let items: [Contact] = contacts.map {
                    var new = $0
                    new.isAdmin = ids.contains($0.mxId)
                    return new
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.chatData.contacts = items.filter { $0.isAdmin } + items.filter { !$0.isAdmin }
                }
            }
        }
    }

    func getRoomAvatarUrl() {
        guard let url = self.matrixUseCase.getRoomAvatarUrl(roomId: self.room.roomId) else { return }
        let homeServer = self.config.matrixURL
        DispatchQueue.main.async {
            self.room.roomAvatar = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
            self.roomAvatarUrl = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
        }
    }

    func getRoomPowerLevels() {
        matrixUseCase.getRoomState(roomId: room.roomId) { [weak self] result in
            guard let self = self else { return }
            guard case let .success(state) = result else { return }
            self.roomPowerLevels = state.powerLevels

            DispatchQueue.main.async {
                if state.powerLevels == nil {
                    self.userHasAccessToMessage = false
                    self.isChannel = true
                    return
                }

                let currentUserId = self.matrixUseCase.getUserId()
                let currentUserPowerLevel = state.powerLevels.powerLevelOfUser(withUserID: currentUserId)
                self.userHasAccessToMessage = currentUserPowerLevel >= state.powerLevels.eventsDefault
                self.isChannel = state.powerLevels.eventsDefault == 50
                self.objectWillChange.send()
            }
        }
    }

    func loadUsers() {
        matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] result in
            debugPrint("getRoomMembers result: \(result)")
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.channelFactory.makeUsersData(
                    users: roomMembers.members(with: .invite) + roomMembers.members(with: .join),
                    roomPowerLevels: self.roomPowerLevels
                )
                debugPrint("getRoomMembers result: \(users)")
                self.participants = users
                self.room.participants = users
            }
        }
    }

    func onNavBarTap(
        chatData: Binding<ChatData>,
        isLeaveChannel: Binding<Bool>
    ) {
        self.room.participants = participants
        coordinator.roomSettings(
            isChannel: isChannel,
            chatData: chatData,
            room: self.room,
            isLeaveChannel: isLeaveChannel,
            coordinator: coordinator
        )
    }

    private func onTapNotSendedMessage(_ event: RoomEvent) {
        self.coordinator.notSendedMessageMenu(event, { type, event in
            self.coordinator.dismissCurrentSheet()
            switch type {
            case .delete:
                self.sendingEvents.removeAll(where: { $0.eventId == event.eventId })
                self.displayItems.removeLast()
            case .resend:
                break
            }
        })
    }

    private func onLongPressMessage(_ event: RoomEvent) {
        let role = channelFactory.detectUserRole(userId: event.sender,
                                                 roomPowerLevels: roomPowerLevels)
        coordinator.messageReactions(event.isFromCurrentUser,
                                     room.isChannel,
                                     role, { action in
            withAnimation(.easeIn(duration: 0.25)) {
                self.activeEditMessage = event
                self.quickAction = action
                self.replyDescriptionText = self.makeReplyDescription(self.activeEditMessage)
                self.coordinator.dismissCurrentSheet()
            }
            debugPrint("Message Action  \(action)")
        }, { reaction in
            self.coordinator.dismissCurrentSheet()
            self.matrixUseCase.react(eventId: event.eventId,
                                     roomId: self.room.roomId,
                                     emoji: reaction)
            self.matrixUseCase.objectChangePublisher.send()
        })
    }
    
    private func makeReplyDescription(_ event: RoomEvent?) -> String {
        guard let event = event else { return "" }
        switch event.eventType {
        case .text(let string):
            return string
        case .image(_):
            return "send to image"
        case .video(_):
            return "send to video"
        case .file(_, _):
            return "send to video"
        case .audio(_):
            return "send to audio"
        case .location(_):
            return "send to location"
        case .contact(_, _, _):
            return "send to contact"
        default:
            return ""
        }
    }

    private func onRemoveReaction(_ event: ReactionNewEvent) {
        guard let userId = event.sendersIds.first(where: { $0 == matrixUseCase.getUserId() }) else { return }
        matrixUseCase.removeReaction(roomId: room.roomId,
                                     text: event.emoji,
                                     eventId: event.relatedEvent) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }

    // MARK: - Internal Methods

    @discardableResult
    func makeOutputEventView(_ type: MessageType,
                             _ isReply: Bool = false) -> RoomEvent {
        let sender = matrixUseCase.getUserId()
        let eventId = UUID().uuidString
        let event = factory.makeChatOutputEvent(eventId,
                                                type, room.roomId,
                                                sender,
                                                matrixUseCase.fromCurrentSender(sender),
                                                isReply)
        sendingEvents.append(event)
        return event
    }

    func changeSedingEvent(_ event: RoomEvent,
                           _ state: RoomSentState = .sent,
                           _ eventId: String = "") {
        if state == .sent {
            guard let index = self.sendingEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
            self.sendingEvents.remove(at: index)
            self.displayItems = self.itemsFromMatrix + self.sendingEventsView
        } else if state == .failToSend {
            guard let index = self.sendingEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
            self.sendingEvents[index].sentState = .failToSend
        }
    }

    func showChatRoomMenu() {
        self.coordinator.chatMenu({ result in
            switch result {
            case .media:
                self.coordinator.galleryPickerSheet(
                    sourceType: .photoLibrary,
                    galleryContent: .all
                ) { [weak self] image in
                    guard let image = image else { return }
                    self?.sendMessage(.image, image: image)
                } onSelectVideo: { [weak self] url in
                    guard let url = url else { return }
                    self?.sendMessage(.video, url: url)
                }
            case .contact:
                self.coordinator.showSelectContact(
                    mode: .send,
                    chatData: Binding(get: {
                        self.chatData
                    }, set: { value in
                        self.chatData = value
                    }),
                    contactsLimit: 1
                ) { contacts in
                    contacts.forEach {
                        self.sendMessage(.contact, contact: $0)
                    }
                }
            case .document:
                self.coordinator.presentDocumentPicker(onCancel: { [weak self] in
                    self?.coordinator.dismissCurrentSheet()
                }, onDocumentsPicked: { [weak self] url in
                    url.forEach {
                        self?.sendMessage(.file, url: $0)
                    }
                })
            case .location:
                self.coordinator.presentLocationPicker(
                    place: Binding(get: {
                        self.location
                    }, set: { value in
                        self.location = value ?? .zero
                    }),
                    sendLocation: Binding(get: {
                        self.isSendLocation
                    }, set: { value in
                        self.isSendLocation = value
                    }), onSendPlace: { [weak self] place in
                        let data = LocationData(lat: place.latitude,
                                                long: place.longitude)
                        self?.sendMessage(.location, location: data)
                    })
            default:
                break
            }
        }, {
            self.coordinator.galleryPickerSheet(sourceType: .camera,
                                                galleryContent: .all) { image in
                guard let image = image else { return }
                self.sendMessage(.image, image: image)
            } onSelectVideo: { url in
                guard let url = url else { return }
                self.sendMessage(.video, url: url)
                self.sendVideo(url, self.makeOutputEventView(.video(url)))
            }
        }, { image in
            self.sendMessage(.image, image: image)
            self.coordinator.dismissCurrentSheet()
        })
    }

    func sendMessage(_ type: MessageSendType,
                     image: UIImage? = nil,
                     url: URL? = nil,
                     record: RecordingDataModel? = nil,
                     location: LocationData? = nil,
                     contact: Contact? = nil) {
        switch type {
        case .text:
            self.sendText()
        case .image:
            guard let image = image else { return }
            let url = URL(fileURLWithPath: "")
            let event = self.makeOutputEventView(.image(url))
            self.sendPhoto(image, event)
        case .video:
            guard let url = url else { return }
            let event = self.makeOutputEventView(.video(url))
            self.sendVideo(url, event)
        case .file:
            guard let url = url else { return }
            let event = self.makeOutputEventView(.file("", url))
            self.sendFile(url, event)
        case .audio:
            guard let record = record else { return }
            let event = self.makeOutputEventView(.audio(record.fileURL))
            self.sendAudio(record, event)
        case .location:
            guard let location = location else { return }
            let event = self.makeOutputEventView(.location((lat: location.lat,
                                                             long: location.long)))
            self.sendMap(location, event)
        case .contact:
            guard var contact = contact else { return }
            // TODO: - поиск id/номера телефона
            apiClient.publisher(Endpoints.Users.users([contact.phone]))
                .replaceError(with: [:])
                .sink { response in
                    debugPrint("Response in  \(response)")
                }
                .store(in: &subscriptions)
            let event = self.makeOutputEventView(.contact(name: contact.name,
                                                          phone: contact.phone,
                                                          url: contact.avatar))
            self.sendContact(contact, event)
        default:
            break
        }
    }
}
