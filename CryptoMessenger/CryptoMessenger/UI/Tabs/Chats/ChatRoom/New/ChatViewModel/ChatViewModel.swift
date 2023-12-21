import Combine
import MatrixSDK
import SwiftUI

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ChatViewModelProtocol {

    @Published var messageText = ""
    @Published var isSnackbarPresented = false
    @Published var isAvatarLoading = false
    @Published var roomAvatarUrl: URL?
    @Published var chatData = ChatData()
    @Published var isKeyboardVisible = false
    @Published var participants: [ChannelParticipantsData] = []
    @Published var displayItems = [any ViewGeneratable]()
    var itemsFromMatrix = [any ViewGeneratable]()
    @Published var inputText = ""
    @Published var scroolString = UUID()
    var scrollIdPublisher: Published<UUID>.Publisher { $scroolString }
    @Published var activeEditMessage: RoomEvent?
    @Published var quickAction: QuickActionCurrentUser?
    @Published var room: AuraRoomData
    @Published var replyDescriptionText = ""
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self
    var coordinator: ChatsCoordinatable
    let mediaService = MediaService()
    let matrixobjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Published var eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()

    // MARK: - Private Properties

    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private let factory: RoomEventsFactory.Type
    let transactionStatusFactory: TransactionStatusFactoryProtocol.Type
    var subscriptions = Set<AnyCancellable>()
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    let p2pCallsUseCase: P2PCallUseCaseProtocol
    let groupCallsUseCase: GroupCallsUseCaseProtocol
    private let config: ConfigType
    private let availabilityFacade: ChatRoomTogglesFacadeProtocol
    let coreDataService: CoreDataServiceProtocol
    let walletModelsFactory: WalletModelsFactoryProtocol.Type
    @Injectable var apiClient: APIClientManager

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
        coordinator: ChatsCoordinatable,
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        walletModelsFactory: WalletModelsFactoryProtocol.Type = WalletModelsFactory.self,
        factory: RoomEventsFactory.Type = RoomEventsFactory.self,
        transactionStatusFactory: TransactionStatusFactoryProtocol.Type = TransactionStatusFactory.self,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared,
        groupCallsUseCase: GroupCallsUseCaseProtocol,
        config: ConfigType = Configuration.shared,
        resources: ChatRoomSourcesable.Type = ChatRoomResources.self,
        availabilityFacade: ChatRoomTogglesFacadeProtocol = ChatRoomViewModelAssembly.build()
    ) {
        self.room = room
        self.coordinator = coordinator
        self.coreDataService = coreDataService
        self.walletModelsFactory = walletModelsFactory
        self.channelFactory = channelFactory
        self.factory = factory
        self.transactionStatusFactory = transactionStatusFactory
        self.p2pCallsUseCase = p2pCallsUseCase
        self.config = config
        self.groupCallsUseCase = groupCallsUseCase
        self.resources = resources
        self.availabilityFacade = availabilityFacade
        bindInput()
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

    private func getCurrentEvents(_ currentRoom: AuraRoomData) -> [RoomEvent] {
        var currentEvents: [RoomEvent] = []
        currentRoom.events.forEach { [weak self] value in
            guard let self = self else { return }
            let item = self.room.events.first(where: { $0.eventId == value.eventId })
            var currentEvent = value
            if item != nil {
                let id = value == item ? item?.id : value.id
                currentEvent = RoomEvent(
                    id: id ?? UUID(),
                    eventId: value.eventId,
                    roomId: value.roomId,
                    sender: value.sender,
                    sentState: value.sentState,
                    eventType: value.eventType,
                    shortDate: value.shortDate,
                    fullDate: value.fullDate,
                    isFromCurrentUser: value.isFromCurrentUser,
                    isReply: value.isReply,
                    reactions: value.reactions,
                    content: value.content,
                    eventSubType: value.eventSubType,
                    eventDate: value.eventDate
                )
                currentEvents.append(currentEvent)
            } else if value.sentState == .sending {
                currentEvents.append(value)
            } else {
                currentEvents.append(currentEvent)
            }
        }
        return currentEvents
    }

    private func getCurrentViews(_ currentEvents: [RoomEvent]) -> [any ViewGeneratable] {
        var currentViews: [any ViewGeneratable] = []
        currentEvents.sorted(by: { $1.eventDate > $0.eventDate }).forEach { [weak self] value in
            guard let self = self else { return }
            if value.sentState == .sent || value.sentState == .sentLocaly {
                let view = self.factory.makeOneEventView(
                    value: value,
                    events: self.room.events,
                    currentEvents: currentEvents,
                    oldViews: self.itemsFromMatrix,
                    delegate: self,
                    onLongPressMessage: { [weak self] event in
                        guard let self = self else { return }
                        self.onLongPressMessage(event)
                    },
                    onReactionTap: { [weak self] reaction in
                        guard let self = self else { return }
                        self.onRemoveReaction(reaction)
                    },
                    onTapNotSendedMessage: { [weak self] event in
                        guard let self = self else { return }
                        self.onTapNotSendedMessage(event)
                    },
                    onSwipeReply: { [weak self] value in
                        guard let self = self else { return }
                        self.activeEditMessage = value
                        self.quickAction = .reply
                        self.replyDescriptionText = self.factory.makeReplyDescription(self.activeEditMessage)
                    }
                )
                if let view = view {
                    currentViews.append(view)
                }
            } else if value.sentState == .sending {
                let sendingView = self.displayItems.first(where: { $0.id == value.id })
                currentViews.append(sendingView ?? ZeroViewModel())
            }
        }
        return currentViews
    }

    private func makeDisplayItems(_ views: [any ViewGeneratable]) -> [any ViewGeneratable] {
        var currentViews: [any ViewGeneratable] = views
        var outputEvents: [RoomEvent] = self.room.events.filter({ $0.sentState == .failToSend }).map {
                let event = RoomEvent(id: $0.id,
                                      eventId: $0.eventId,
                                      roomId: $0.roomId,
                                      sender: $0.sender,
                                      sentState: $0.sentState,
                                      eventType: $0.eventType,
                                      shortDate: $0.shortDate,
                                      fullDate: $0.fullDate,
                                      isFromCurrentUser: $0.isFromCurrentUser,
                                      isReply: $0.isReply,
                                      reactions: [],
                                      content: $0.content,
                                      eventSubType: $0.eventSubType,
                                      eventDate: Date(),
                                      senderAvatar: $0.senderAvatar,
                                      videoThumbnail: $0.videoThumbnail)
                return event
            }
        outputEvents.forEach { [weak self] value in
            guard let self = self else { return }
            let view = self.factory.makeOneEventView(
                value: value,
                events: [],
                currentEvents: self.room.events,
                oldViews: [],
                delegate: self,
                onLongPressMessage: { _ in },
                onReactionTap: { _ in },
                onTapNotSendedMessage: { [weak self] event in
                    guard let self = self else { return }
                    self.onTapNotSendedMessage(event)
                },
                onSwipeReply: { _ in }
            )
            if let view = view {
                currentViews.append(view)
            }
        }
        return currentViews
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
                    self.matrixUseCase.objectChangePublisher.send()
                    self.loadUsers()
                    guard let mxRoom = self.matrixUseCase.getRoomInfo(
                        roomId: self.room.roomId
                    ),
                          let auraRoom = self.matrixobjectFactory.makeAuraRooms(
                            mxRooms: [mxRoom],
                            isMakeEvents: false,
                            config: self.config,
                            eventsFactory: RoomEventObjectFactory(),
                            matrixUseCase: self.matrixUseCase
                          ).first
                    else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.updateToggles()
                        self.room = auraRoom
                        self.roomAvatarUrl = auraRoom.roomAvatar
                        self.objectWillChange.send()
                    }
                    self.matrixUseCase.markAllAsRead(roomId: self.room.roomId)
                    self.updateData()
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
                    let currentRoom = self.matrixUseCase.auraRooms.first(where: { $0.roomId == self.room.roomId })
                else {
                    return
                }
                self.updateRoomPowerLevel()
                let currentEvents: [RoomEvent] = self.getCurrentEvents(currentRoom)
                var currentViews: [any ViewGeneratable] = self.getCurrentViews(currentEvents)
                currentViews = self.makeDisplayItems(currentViews)
                self.itemsFromMatrix = currentViews
                self.room = currentRoom
                self.room.events = currentEvents
                self.displayItems = self.itemsFromMatrix
                delay(0.1) {
                    guard !self.itemsFromMatrix.isEmpty else { return }
                    self.scroolString = self.displayItems.last?.id ?? UUID()
                }
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)

        p2pVideoCallPublisher
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                debugPrint("Place_Call: p2pVideoCallPublisher")
                guard let self = self else { return }
                self.updateToggles()

                if self.isGroupCall {
                    self.groupCallsUseCase.placeGroupCallInRoom(roomId: self.room.roomId)
                    return
                }
                self.p2pCallsUseCase.placeVideoCall(
                    roomId: self.room.roomId,
                    contacts: self.chatData.contacts
                )
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
        // проверка на уже присоединенную комнату
        guard let isInvited: Bool = self.matrixUseCase.isInvitedToRoom(
            roomId: room.roomId
        ), isInvited == true else {
            return
        }
        debugPrint("MATRIX DEBUG ChatViewModel matrixUseCase.joinRoom isInvited \(isInvited)")
        debugPrint("MATRIX DEBUG ChatViewModel joinRoom: \(roomId)")
        self.matrixUseCase.joinRoom(roomId: room.roomId) { response in
            debugPrint("MATRIX DEBUG ChatViewModel matrixUseCase.joinRoom \(response)")
        }
    }

    func updateData() {
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
                self?.setRoomPowerLevel(roomState)
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

    private func updateRoomPowerLevel() {
        self.matrixUseCase.getRoomState(roomId: self.room.roomId) { [weak self] response in
            guard case let .success(roomState) = response else { return }
            self?.setRoomPowerLevel(roomState)
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

    private func setRoomPowerLevel(_ state: MXRoomState) {
        DispatchQueue.main.async {
            if state.powerLevels == nil {
                self.userHasAccessToMessage = false
                self.isChannel = true
                return
            }
            self.roomPowerLevels = state.powerLevels
            let currentUserId = self.matrixUseCase.getUserId()
            let currentUserPowerLevel = state.powerLevels.powerLevelOfUser(withUserID: currentUserId)
            self.userHasAccessToMessage = currentUserPowerLevel >= state.powerLevels.eventsDefault
            self.isChannel = state.powerLevels.eventsDefault == 50
            self.objectWillChange.send()
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
        self.coordinator.notSendedMessageMenu(
            event: event,
            onTapItem: { type, event in
            self.coordinator.dismissCurrentSheet()
            switch type {
            case .delete:
                self.room.events = self.room.events.filter({ $0.eventId != event.eventId })
                self.displayItems = self.displayItems.filter({  $0.id != event.id })
            case .resend:
                break
            }
        })
    }

    private func onLongPressMessage(_ event: RoomEvent) {
        let role = channelFactory.detectUserRole(
            userId: event.sender,
            roomPowerLevels: roomPowerLevels
        )
        coordinator.messageReactions(
            messageType: event.eventType,
            hasReactions: !event.reactions.isEmpty,
            hasAccessToWrite: userHasAccessToMessage,
            isCurrentUser: event.isFromCurrentUser,
            isChannel: room.isChannel,
            userRole: role,
            onAction: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .reply:
                    self.setEditedOrReplyEvent(event, action)
                case .edit:
                    switch event.eventType {
                    case .text(_):
                        self.setEditedOrReplyEvent(event, action)
                    default:
                        self.coordinator.dismissCurrentSheet()
                    }
                case .delete:
                    self.removeMessage(event.eventId)
                    self.matrixUseCase.redact(roomId: self.room.roomId,
                                              eventId: event.eventId, reason: nil)
                    self.coordinator.dismissCurrentSheet()
                default:
                    break
                }
                debugPrint("Message Action  \(action)")
            },
            onReaction: { [weak self] reaction in
                guard let self = self else { return }
                self.coordinator.dismissCurrentSheet()
                self.matrixUseCase.react(
                    eventId: event.eventId,
                    roomId: self.room.roomId,
                    emoji: reaction
                )
            }
        )
    }

    private func setEditedOrReplyEvent(_ event: RoomEvent, _ action: QuickActionCurrentUser) {
        withAnimation(.easeIn(duration: 0.25)) {
            self.activeEditMessage = event
            self.quickAction = action
            self.replyDescriptionText = self.factory.makeReplyDescription(self.activeEditMessage)
            self.coordinator.dismissCurrentSheet()
        }
    }

    private func removeMessage(_ eventId: String) {
        guard let event = self.room.events.first(where: { $0.eventId == eventId }) else { return }
        
        self.room.events = self.room.events.filter({ $0.eventId != eventId })
        self.displayItems = self.displayItems.filter({ $0.id != event.id })
    }

    private func onRemoveReaction(_ event: ReactionNewEvent) {
        guard let userId = event.sendersIds.first(where: { $0 == matrixUseCase.getUserId() }) else { return }
        matrixUseCase.removeReaction(
            roomId: room.roomId,
            text: event.emoji,
            eventId: event.relatedEvent
        ) { [weak self] _ in
            guard let self = self else { return }
            self.matrixUseCase.objectChangePublisher.send()
        }
    }

    // MARK: - Internal Methods

    @discardableResult
    func makeOutputEventView(_ type: MessageType,
                             _ isReply: Bool = false) -> RoomEvent {
        let sender = matrixUseCase.getUserId()
        let eventId = UUID()
        let event = factory.makeChatOutputEvent(eventId,
                                                eventId.uuidString,
                                                type, room.roomId,
                                                sender,
                                                matrixUseCase.fromCurrentSender(sender),
                                                isReply)
        return event
    }

    func changeSedingEvent(
        event: RoomEvent,
        state: RoomSentState = .sentLocaly,
        eventId: String = ""
    ) {
        guard let index = self.room.events.firstIndex(of: event) else { return }
        self.room.events.remove(at: index)
        let newEvent = RoomEvent(
            id: event.id,
            eventId: eventId,
            roomId: event.roomId,
            sender: event.sender,
            sentState: state,
            eventType: event.eventType,
            shortDate: event.shortDate,
            fullDate: event.fullDate,
            isFromCurrentUser: event.isFromCurrentUser,
            isReply: event.isReply,
            reactions: event.reactions,
            content: event.content,
            eventSubType: event.eventSubType,
            eventDate: event.eventDate
        )
        guard let view = factory.makeOneEventView(
            value: newEvent,
            events: room.events,
            currentEvents: room.events,
            oldViews: displayItems,
            delegate: self,
            onLongPressMessage: { _ in },
            onReactionTap: { _ in },
            onTapNotSendedMessage: { [weak self] event in
                self?.onTapNotSendedMessage(event)
            },
            onSwipeReply: { _ in }
        ) else {
            return
        }
        guard let existingViewIndex = self.displayItems.firstIndex(where: { $0.id == newEvent.id }) else { return }
        if state == .sentLocaly {
            self.displayItems.append(view)
            self.room.events.append(newEvent)
        } else {
            self.displayItems[existingViewIndex] = view
            self.room.events.insert(newEvent, at: index)
        }
    }

    func sendMessage(
        type: MessageSendType,
        image: UIImage? = nil,
        url: URL? = nil,
        record: RecordingDataModel? = nil,
        location: LocationData? = nil,
        contact: Contact? = nil
    ) {
        switch type {
        case .text:
            let event = self.makeOutputEventView(.text(inputText))
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendText()
        case .image:
            guard let image = image else { return }
            let url = URL(fileURLWithPath: "")
            let event = self.makeOutputEventView(.image(url))
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendPhoto(image, event)
        case .video:
            guard let url = url else { return }
            let event = self.makeOutputEventView(.video(url))
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendVideo(url, event)
        case .file:
            guard let url = url else { return }
            let event = self.makeOutputEventView(.file("", url))
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendFile(url, event)
        case .audio:
            guard let record = record else { return }
            let event = self.makeOutputEventView(.audio(record.fileURL))
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendAudio(
                record: record,
                event: event
            )
        case .location:
            guard let location = location else { return }
                let event = self.makeOutputEventView(
                    .location(
                        (lat: location.lat,
                               long: location.long)
                    )
                )
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendMap(location, event)
        case .contact:
            guard let contact = contact else { return }
            // TODO: - поиск id/номера телефона
            apiClient.publisher(Endpoints.Users.users([contact.phone]))
                .replaceError(with: [:])
                .sink { response in
                    debugPrint("Response in  \(response)")
                }
                .store(in: &subscriptions)

                let event = self.makeOutputEventView(
                    .contact(
                        name: contact.name,
                        phone: contact.phone,
                        url: contact.avatar
                    )
                )
            self.addOutputEvent(event: event)
            self.scrollToBottom()
            self.sendContact(contact, event)
        default:
            break
        }
        isKeyboardVisible = true
    }

    private func addOutputEvent(event: RoomEvent) {
        guard let view = self.factory.makeOneEventView(
            value: event,
            events: self.room.events,
            currentEvents: self.room.events,
            oldViews: self.displayItems,
            delegate: self,
            onLongPressMessage: { _ in },
            onReactionTap: { _ in },
            onTapNotSendedMessage: { _ in },
            onSwipeReply: { _ in }
        ) else {
            return
        }
        self.room.events.append(event)
        self.displayItems.append(view)
    }

    func showSnackBar(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }

        delay(3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }
}
