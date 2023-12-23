import Combine
import SwiftUI
import UIKit

// MARK: - ChatRoomViewModel
// swiftlint:disable all
final class ChatRoomViewModel: ObservableObject {

    // MARK: - Internal Properties
    
    var coordinator: ChatsCoordinatable?

    @Published var chatData = ChatData()
    @Published var saveData = false
    @Published var inputText = ""
    @Published var attachAction: AttachAction?
    @Published var directAction: DirectAction?
    @Published var translateAction: TranslateAction?
    @Published var dismissScreen = false
    @Published var showSettings = false
    @Published var isOneDayMessages = false
    @Published var rooms: [AuraRoom] = []
    @Published var participants: [ChannelParticipantsData] = []

    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var emojiStorage: [ReactionStorage] = []
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published private(set) var userMessage: Message?
    @Published private(set) var room: AuraRoom
    @Published var messages: [RoomMessage] = []
    @Published var translatedMessages: [RoomMessage] = []
    @Published var photosToSend: [UIImage] = []
    @Published var showTranslate = false
    @Published var showTranslateMenu = false
    @Published var selectedImage: UIImage?
    @Published var selectedVideo: URL?
    @Published var pickedImage: UIImage?
    @Published var pickedContact: [Contact]?
    @Published var pickedLocation: Place?
    @Published var cameraFrame: CGImage?
    @Published var roomUsers = [MXUser]()
    @Published var sendLocationFlag = false
    @Published var audioUrl: RecordingDataModel?
	var p2pVideoCallPublisher = ObservableObjectPublisher()
	var p2pVoiceCallPublisher = ObservableObjectPublisher()
	var groupCallPublisher = ObservableObjectPublisher()


	@Published var isVoiceCallAvailablility: Bool = false
	@Published var isVideoCallAvailablility: Bool = false
    @Published var isChatGroupMenuAvailable: Bool = false
    @Published var isChatDirectMenuAvailable: Bool = false
    @Published var isReactionsAvailable: Bool = false
    @Published var isVideoMessageAvailable: Bool = false
    @Published var roomAvatarUrl: URL?
    @Published var isAvatarLoading = false

	private let groupCallsUseCase: GroupCallsUseCaseProtocol

	var isGroupCall: Bool {
        room.room.isDirect == false && availabilityFacade.isGroupCallsAvailable && !self.isChannel
	}

	var isVoiceCallAvailable: Bool {
		availabilityFacade.isCallAvailable && room.room.isDirect && !self.isChannel
	}

	var isVideoCallAvailable: Bool {
		availabilityFacade.isVideoCallAvailable && room.room.isDirect && !self.isChannel
	}

    let resources: ChatRoomSourcesable.Type
    var userHasAccessToMessage: Bool = true
    var isChannel: Bool = false
    
    

    // MARK: - Private Properties
    
    private var roomPowerLevels: MXRoomPowerLevels?
    private let eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keyboardObserver = KeyboardObserver()
    private let mediaService = MediaService()
	private let p2pCallsUseCase: P2PCallUseCaseProtocol
	private let availabilityFacade: ChatRoomTogglesFacadeProtocol
	private let settings: UserDefaultsServiceCallable

    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var translateManager: TranslateManager
    @Injectable private var locationManager: LocationManagerUseCaseProtocol
	private let componentsFactory: ChatComponentsFactoryProtocol
    private var pushNotification = PushNotificationsService()
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let factory: ChannelUsersFactoryProtocol.Type
    private let config: ConfigType

    var toggleFacade: MainFlowTogglesFacadeProtocol
    
    private let eventsFactory: RoomEventsFactoryProtocol.Type
    private let pasteboardService: PasteboardServiceProtocol
    
    // MARK: - Lifecycle

    init(
		room: AuraRoom,
		p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared,
		availabilityFacade: ChatRoomTogglesFacadeProtocol = ChatRoomViewModelAssembly.build(), 
        toggleFacade: MainFlowTogglesFacadeProtocol,
        locationManager: LocationManagerUseCaseProtocol = LocationManagerUseCase(),
		settings: UserDefaultsServiceCallable = UserDefaultsService.shared,
        resources: ChatRoomSourcesable.Type = ChatRoomResources.self,
		componentsFactory: ChatComponentsFactoryProtocol = ChatComponentsFactory(),
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
		groupCallsUseCase: GroupCallsUseCaseProtocol,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        config: ConfigType = Configuration.shared,
        eventsFactory: RoomEventsFactoryProtocol.Type = RoomEventsFactory.self,
        pasteboardService: PasteboardServiceProtocol = PasteboardService()
	) {
        self.resources = resources
        self.room = room
		self.p2pCallsUseCase = p2pCallsUseCase
		self.settings = settings
		self.availabilityFacade = availabilityFacade
        self.toggleFacade = toggleFacade
		self.componentsFactory = componentsFactory
		self.groupCallsUseCase = groupCallsUseCase
        self.userSettings = userSettings
        self.factory = factory
        self.eventsFactory = eventsFactory
        self.pasteboardService = pasteboardService
        self.config = config
		self.locationManager = locationManager
		updateToggles()
        bindInput()
        bindOutput()
		subscribeToNotifications()

        keyboardObserver.keyboardWillShowHandler = { [weak self] notification in
            guard
                let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
            }
            self?.keyboardHeight = keyboardFrame.size.height
        }
        keyboardObserver.keyboardWillHideHandler = { [weak self] _ in
            self?.keyboardHeight = 0
        }
        fetchChatData()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
		NotificationCenter.default.removeObserver(self)
    }

	private func updateToggles() {
		let isP2PChat = room.room.isDirect == true && room.room.summary?.membersCount?.joined == 2
        let call = room.room.mxSession.callManager.call(inRoom: room.room.roomId)
        let isCallInProgress = p2pCallsUseCase.isActiveCallExist && (call != nil)
		let isCallAvailable = availabilityFacade.isCallAvailable
        self.isVoiceCallAvailablility = isCallAvailable && isP2PChat && !isCallInProgress
        self.isChatDirectMenuAvailable = availabilityFacade.isChatDirectMenuAvailable
        self.isChatGroupMenuAvailable = availabilityFacade.isChatGroupMenuAvailable
		let isVideoCallAvailable = availabilityFacade.isVideoCallAvailable
		self.isVideoCallAvailablility = isVideoCallAvailable && isP2PChat && !isCallInProgress
        self.isReactionsAvailable = availabilityFacade.isReactionsAvailable
        self.isVideoMessageAvailable = availabilityFacade.isVideoMessageAvailable
	}

	private func subscribeToNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didUpdateCallState),
			name: .callStateDidChange,
			object: nil
		)
	}

	@objc private func didUpdateCallState() {
		updateToggles()
	}

    // MARK: - Internal Methods
    
    func channelTransition(_ message: RoomMessage) {
        var roomId = ""
        switch message.type {
        case let .text(string):
            roomId = string
        default:
            return
        }
        guard let existingRoom = self.rooms.first(where: { $0.room.roomId == roomId }) else {
            self.joinRoom(roomId)
            return
        }
        if existingRoom.room.roomId != self.room.room.roomId {
            if let coordinator = coordinator {
                self.coordinator?.firstAction(room: existingRoom)
            }
        }
    }
    
    func joinRoom(_ roomId: String) {
        self.matrixUseCase.joinRoom(roomId: roomId) { [weak self] _ in
            guard let newRoom = self?.matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {
                return
            }
            self?.coordinator?.firstAction(room: newRoom)
        }
    }
    
    func onCopyTap(text: String) {
        pasteboardService.copyToPasteboard(text: text)
    }

    func send(_ event: ChatRoomFlow.Event) {
        eventSubject.send(event)
    }
    
    func isFirst(_ item: RoomMessage?) -> Bool {
        if room.events().renderableEvents.last?.eventId == item?.eventId {
            return true
        } else {
            return false
        }
    }
    
    func getUserRole() -> ChannelRole {
        let role = factory.detectUserRole(userId: matrixUseCase.getUserId(),
                               roomPowerLevels: roomPowerLevels)
        return role
    }

    func next(_ item: RoomMessage) -> RoomMessage? {
        // TODO: Разобрать модель RoomMessage и заменить на выход переведенное сообщение если рубильник включен.
        if translateManager.isActive {
            return translatedMessages.next(item: item)
        } else {
            return messages.next(item: item)
        }
    }

    func previous(_ item: RoomMessage) -> RoomMessage? {
        if translateManager.isActive {
            return translatedMessages.previous(item: item)
        } else {
            return messages.previous(item: item)
        }
    }

    func fromCurrentSender(_ userId: String) -> Bool {
        matrixUseCase.fromCurrentSender(userId)
    }
    
    func getMenuStatus() -> Bool {
        if room.isDirect {
            return isChatDirectMenuAvailable
        } else {
            return isChatGroupMenuAvailable
        }
    }
    
    func translateMessagesTo(languageCode: String) {
        showTranslateMenu = false
        self.translatedMessages.removeAll()

        for message in self.messages {
            self.translateTo(languageCode: languageCode, message: message)
        }
    }
    
    func sendPhotos(images: [UIImage]) {
        for photo in images {
            self.send(.onSendImage(photo))
        }
    }

    func updateRecorde(item: RecordingDataModel) {
        self.audioUrl = item
    }
    
    func isTranslating() -> Bool {
        return translateManager.isActive
    }
    
    func translateTo(languageCode: String, message: RoomMessage) {
        self.translateManager.isActive = true

        DispatchQueue.main.async {
            guard !message.isCurrentUser else {
                self.translatedMessages.append(message)
                self.translatedMessages = self.translatedMessages.sorted(by: { $0.id < $1.id })
                return
            }
        }
        var message = message
        switch message.type {
        case let .text(text):
            translateManager.detect(text) { (locales, error) in
                guard let locales = locales, error == nil else {
                    self.translateManager.isActive = false
                    return
                }
                // Language check
                if Locale.current.languageCode != nil {
                    self.translateManager.translate(text, locales[0].language, languageCode, "text", "base") { (translate , error) in
                        DispatchQueue.main.async {
                            // TODO: Улучшить обработку перевода, без собственных сообщений
                            if let translate = translate {
                                message.type = .text(translate)
                            }
                            self.translatedMessages.append(message)
                            self.translatedMessages = self.translatedMessages.sorted(by: { $0.id < $1.id })
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    // Пока не вызвается, возможно понадобится 
    private func updateEventDefaultAndStateDefault() {
        
        room.room.state { [weak self] roomState in
            
            guard let roomId = self?.room.room.roomId,
                var levels = roomState?.powerLevels?.jsonDictionary() else { return }
            
            levels["users_default"] = NSNumber(integerLiteral: 0)
            levels["events_default"] = NSNumber(integerLiteral: 50)
            levels["stateDefault"] = NSNumber(integerLiteral: 50)
            levels["invite"] = NSNumber(integerLiteral: 50)
            
            self?.matrixUseCase.matrixSession?.matrixRestClient.aur_sendStateEvent(
                toRoom: roomId,
                eventType: kMXEventTypeStringRoomPowerLevels,
                content: levels,
                stateKey: nil,
                success: { successResult in
                    debugPrint("successResult \(successResult)")
                },
                failure: { failureResult in
                    debugPrint("failureResult \(failureResult)")
                })
        }
    }
    
    func loadUsers() {
        matrixUseCase.getRoomMembers(roomId: room.room.roomId) { [weak self] result in
            debugPrint("getRoomMembers result: \(result)")
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.factory.makeUsersData(users: roomMembers.members, roomPowerLevels: self.roomPowerLevels)
                self.participants = users
                self.objectWillChange.send()
            }
        }
    }
    
    private func detectRoomPowerLevelAccess() {
        
        let currentUserId = matrixUseCase.getUserId()
        
        matrixUseCase.getRoomState(roomId: room.room.roomId) { [weak self] result in
            
            guard case let .success(state) = result else { return }
            
            if state.powerLevels == nil {
                self?.userHasAccessToMessage = false
                self?.isChannel = true
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                let currentUserPowerLevel = state.powerLevels.powerLevelOfUser(withUserID: currentUserId)
                self?.userHasAccessToMessage = currentUserPowerLevel >= state.powerLevels.eventsDefault
                self?.isChannel = state.powerLevels.eventsDefault == 50
                self?.objectWillChange.send()
            }
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
                    self.loadUsers()
                    self.matrixUseCase.markAllAsRead(roomId: self.room.room.roomId)
                    self.detectRoomPowerLevelAccess()
                    self.matrixUseCase.objectChangePublisher.send()
                    self.fetchChatData()
                case let .onCamera(image, video):
                    guard let self = self else { return }
                    self.coordinator?.galleryPickerFullScreen(sourceType: .camera,
                                                              galleryContent: .all, onSelectImage: { newImage in
                        if let newImage = newImage {
                            image.wrappedValue = newImage
                        }
                    }, onSelectVideo: { videoUrl in
                        if let videoUrl = videoUrl {
                            video.wrappedValue = videoUrl
                        }
                    })
                case .onNextScene:
                    ()
                case let .onSendText(text):
                    self?.inputText = ""
                    guard let id = self?.room.room.roomId else { return }
                    self?.matrixUseCase.sendText(id,
                                                 text,
                                                 completion: { _ in
                        self?.matrixUseCase.objectChangePublisher.send()
                        self?.fetchChatData()
                    })
                case let .onSendImage(image):
                    self?.inputText = ""
                    guard let id = self?.room.room.roomId else { return }
                    self?.mediaService.uploadChatPhoto(roomId: id,
                                                       image: image) { _ in
                        // self?.room.updateEvents(eventId: eventId)
                    }
                    self?.matrixUseCase.objectChangePublisher.send()
                case let .onSendVideo(url):
                    guard let self = self else { return }
                    if self.isVideoMessageAvailable {
                        guard let id = self.room.room.roomId else { return }
                        let mxImage = MXImage(systemName: "eraser")
                        self.mediaService.uploadVideoMessage(for: id,
                                                              url: url,
                                                              thumbnail: mxImage,
                                                              completion: { _ in
                                // self.room.updateEvents(eventId: eventId)
                        })
                    }
                case let .onSendLocation(location):
                    self?.inputText = ""
                    guard let id = self?.room.room.roomId else { return }
                    self?.matrixUseCase.sendLocation(roomId: id,
                                                     location: location, completion: { _ in
                        self?.send(.onAppear(nil))
                        self?.matrixUseCase.objectChangePublisher.send()
                    })
                case let .onSendFile(url):
                    self?.inputText = ""
                    guard let id = self?.room.room.roomId else { return }
                    DispatchQueue.global(qos: .background).async {
                        self?.mediaService.uploadChatFile(roomId: id,
                                                          url: url) { result in
                            switch result {
                            case .success(let success):
                                self?.room.updateEvents(eventId: success)
                            default:
                                break
                            }
                        }
                        self?.matrixUseCase.objectChangePublisher.send()
                    }
                case let .onSendAudio(url, duration):
                    self?.inputText = ""
                    guard let id = self?.room.room.roomId else { return }
                    self?.mediaService.uploadVoiceMessage(roomId: id,
                                                          audio: url,
                                                          duration: UInt(duration),
                                                          completion: { result in
                        switch result {
                        case .success(let success):
                            self?.room.updateEvents(eventId: success)
                        default:
                            break
                        }
                    })
                    self?.matrixUseCase.objectChangePublisher.send()
                case let .onSendContact(contact):
                    guard let id = self?.room.room.roomId else { return }
                    self?.mediaService.uploadChatContact(roomId: id,
                                                         contact: contact) { result in
                        switch result {
                        case .success(let success):
                            self?.room.updateEvents(eventId: success)
                        default:
                            break
                        }
                    }
                    self?.matrixUseCase.objectChangePublisher.send()
                case .onJoinRoom:
                    guard let roomId = self?.room.room.roomId else { return }
                    self?.matrixUseCase.joinRoom(roomId: roomId) { _ in
                        self?.send(.onAppear(nil))
						self?.updateToggles()
                    }
                case let .onReply(text, eventId):
                    // self.matrixUseCase.sendReply(eventId, text)
                    self?.matrixUseCase.objectChangePublisher.send()
                    self?.fetchChatData()
                case let .onDelete(eventId):
                    guard let self = self else { return }
                    self.matrixUseCase.redact(roomId: self.room.room.roomId,
                                               eventId: eventId, reason: nil)
                    self.matrixUseCase.objectChangePublisher.send()
                case .onAddReaction(let messageId, let reactionId):
					guard ((self?.isTranslating()) != nil) else {
						guard
							let index = self?.translatedMessages.firstIndex(where: { $0.id == messageId }),
							let emoji = self?.emojiStorage.first(where: { $0.id == reactionId })?.emoji
						else {
							return
						}

						if self?.translatedMessages[index].reactions.contains(where: { $0.id == reactionId }) == false {
							self?.translatedMessages[index].reactions.append(
								.init(id: reactionId, sender: "", timestamp: Date(), emoji: emoji)
							)
						}
						return
					}
					guard
						let index = self?.messages.firstIndex(where: { $0.id == messageId }),
						let message = self?.messages.first(where: { $0.id == messageId }),
						message.reactions.contains(where: { $0.emoji == reactionId && $0.isFromCurrentUser == true }) == false
					else {
						return
					}

					self?.react(toEventId: messageId, emoji: reactionId)

					let sender = self?.matrixUseCase.getUserId() ?? ""
					let reaction = Reaction(
						id: reactionId,
						sender: sender,
						timestamp: Date(),
						emoji: reactionId,
						isFromCurrentUser: message.sender == sender
					)
					self?.messages[index].reactions.append(reaction)
                case let .onMedia(room):
                    break
                    //self?.coordinator?.chatMedia(room)
                case .onDeleteReaction(let messageId, let reactionId):
                    guard let self = self else { return }
                    self.matrixUseCase.edit(roomId: self.room.room.roomId,
                                             text: "",
                                            eventId: messageId)
                    guard let index = self.messages.firstIndex(where: { $0.id == messageId }) else { return }
                    self.messages[index].reactions.removeAll(where: { $0.id == reactionId })
                    self.matrixUseCase.objectChangePublisher.send()
                case let .onEdit(text, eventId):
                    guard let self = self else { return }
                    self.matrixUseCase.edit(roomId: self.room.room.roomId,
                                            text: text, eventId: eventId)
                case let .onSettings(chatData: chatData, saveData: saveData,
                                     room: room, isLeaveChannel: isLeaveChannel):
                    guard let isChannel = self?.isChannel else { return }
                }
            }
            .store(in: &subscriptions)

        $attachAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .location:
                    self.coordinator?.presentLocationPicker(
                        place: Binding(get: {
                            self.pickedLocation
                        }, set: { value in
                            self.pickedLocation = value
                        }),
                        sendLocation: Binding(get: {
                            self.sendLocationFlag
                        }, set: { value in
                            self.sendLocationFlag = value
                        }), onSendPlace: { _ in }
                    )
                case .media:
                    self.coordinator?.galleryPickerSheet(
                        sourceType: .photoLibrary,
                        galleryContent: .photos,
                        onSelectImage: { [weak self] image in
                            if let image = image {
                                self?.selectedImage = image
                            }
                        }, onSelectVideo: { [weak self] videoUrl in
                            if let video = videoUrl {
                                self?.selectedVideo = video
                            }
                        })
                case .document:
                    self.coordinator?.presentDocumentPicker(onCancel: nil) { [weak self] urls in
                        guard !urls.isEmpty, let url = urls.first else { return }
                        self?.send(.onSendFile(url))
                    }
                case .contact:
                    self.coordinator?.showSelectContact(
                        mode: .send,
                        chatData: Binding(get: {
                            self.chatData
                        }, set: { value in
                            self.chatData = value
                        }),
                        contactsLimit: 1
                    ) { value in
                        value.map {
                            self.eventSubject.send(.onSendContact($0))
                        }
                    }
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        $directAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .translate:
                    self?.showTranslate = true
                case .delete:
                    self?.dismissScreen = true
                    guard let roomId = self?.room.room.roomId else { return }
                    self?.matrixUseCase.leaveRoom(roomId: roomId,
                                                  completion: { _ in })
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        $audioUrl
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let url = result?.fileURL else { return }
                guard let duration = result?.duration else { return }
                self?.send(.onSendAudio(url, duration))
            }
            .store(in: &subscriptions)
        
        $translateAction
            .receive(on: DispatchQueue.main)
            .sink { action in
                switch action {
                case .russian:
                    self.translateMessagesTo(languageCode: "ru")
                case .system, .none:
                    // TODO: Когда решим по поводу перевода на дефолт
//                    let languageLocale = TranslateManager.shared.languagesList.filter{$0.language == Locale.current.languageCode}
//                    if !languageLocale.isEmpty {
//                        self.translateMessagesTo(languageCode: languageLocale[0].language)
//                    }
                    self.translateManager.isActive = false
                    self.translatedMessages = self.messages
                case .italian:
                    self.translateMessagesTo(languageCode: kLanguageItalian)
                case .english:
                    self.translateMessagesTo(languageCode: kLanguageEnglish)
                case .spanish:
                    self.translateMessagesTo(languageCode: kLanguageSpanish)
                case .french:
                    self.translateMessagesTo(languageCode: kLanguageFrench)
                case .arabic:
                    self.translateMessagesTo(languageCode: kLanguageArabic)
                case .german:
                    self.translateMessagesTo(languageCode: kLanguageGerman)
                case .chinese:
                    self.translateMessagesTo(languageCode: kLanguageChinese)
                }
            }
            .store(in: &subscriptions)
        
        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    self?.send(.onSendImage(image))
                }
            }
            .store(in: &subscriptions)

        $selectedVideo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] videoUrl in
                guard let videoUrl = videoUrl else { return }
                self?.send(.onSendVideo(videoUrl))
            }
            .store(in: &subscriptions)

        $pickedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onSendImage(image))
            }
            .store(in: &subscriptions)

        $pickedContact
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contact in
                guard let contacts = contact else { return }
                print("slkasklaswlkaslk   \(contacts)")
                for contact in contacts {
                    self?.send(.onSendContact(contact))
                }
            }
            .store(in: &subscriptions)
        $pickedLocation
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let flag = self?.sendLocationFlag else { return }
                
                if flag  {
                    location.map { location in
						// TODO: Разобраться, это так и должно заполняться?
                        let message = RoomMessage(
                            id: UUID().uuidString,
							sender: "",
                            type: .location((lat: location.latitude, long: location.longitude)),
                            shortDate: Date().hoursAndMinutes,
                            fullDate: Date().dayAndMonthAndYear,
                            isCurrentUser: true,
                            isReply: false,
                            name: "",
                            avatar: nil,
                            content: [String: Any](),
                            eventType: ""
                        )
                        debugPrint("Last location sink", (lat: location.latitude, long: location.longitude))
                        guard let id = self?.room.room.roomId else { return }
                        self?.matrixUseCase.sendLocation(roomId: id,
                                                         location: LocationData(lat: location.latitude, long: location.longitude), completion: { _ in
                            self?.send(.onAppear(nil))
                            self?.matrixUseCase.objectChangePublisher.send()
                        })
                    }
                }
            }
            .store(in: &subscriptions)
        $saveData
            .sink { [weak self] flag in
                guard let room = self?.room.room, flag else { return }

                if let name = self?.chatData.title {
                    room.setName(name) { _ in }
                }

                if let topic = self?.chatData.description {
                    room.setTopic(topic) { _ in }
                }
                if let data = self?.chatData.image?.jpeg(.medium) {
                    self?.isAvatarLoading = true
                    self?.objectWillChange.send()
                    self?.matrixUseCase.uploadData(data: data, for: room) { [weak self] url in
                        guard let url = url else { return }
                        room.setAvatar(url: url) { [weak self] _ in
                            guard let self = self else { return }
                            let homeServer = self.config.matrixURL
                            self.roomAvatarUrl = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
                            self.isAvatarLoading = false
                            self.mediaService.downloadData(self.roomAvatarUrl) { data in
                                guard let data = data else { return }
                                DispatchQueue.main.async { self.chatData.image = UIImage(data: data) }
                            }
                        }
                    }
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let room = self.matrixUseCase.rooms.first(where: { $0.room.id == self.room.id })
                else {
                    return
                }
                if self.isTranslating() {
                    self.translatedMessages = room.events().renderableEvents.filter({ !$0.eventId.contains("kMXEventLocalId") })
                        .map {
                            var message = $0.message(self.fromCurrentSender($0.sender))
                            message?.eventId = $0.eventId
                            var user: MXUser?
                            if !$0.userId.isEmpty {
                                user = self.matrixUseCase.getUser($0.userId)
                            } else {
                                user = self.matrixUseCase.getUser($0.sender)
                            }
                            if let user = user {
                                self.roomUsers.append(user)
                            }
                            message?.name = user?.displayname ?? ""
                            let homeServer = self.config.matrixURL
                            message?.avatar = MXURL(mxContentURI: user?.avatarUrl ?? "")?.contentURL(on: homeServer)
                            return message
                        }
                        .compactMap { $0 }
                }
                self.messages = room.events().renderableEvents.filter({ !$0.eventId.contains("kMXEventLocalId") })
                    .map {
                        var message = $0.message(self.fromCurrentSender($0.sender))
						message?.reactions = room.events().reactions(
							forEvent: $0,
							currentUserId: self.matrixUseCase.getUserId()
						)
                        message?.eventId = $0.eventId
                        var user: MXUser?
                        if !$0.userId.isEmpty {
                            user = self.matrixUseCase.getUser($0.userId)
                        } else {
                            user = self.matrixUseCase.getUser($0.sender)
                        }
                        if let user = user {
                            self.roomUsers.append(user)
                        }
                        message?.name = user?.displayname ?? ""
                        let homeServer = self.config.matrixURL
                        message?.avatar = MXURL(mxContentURI: user?.avatarUrl ?? "")?.contentURL(on: homeServer)
                        message?.videoThumbnail = $0.videoThumbnail
                        return message
                    }
                    .compactMap { $0 }
                let messagesFullDate: [String] = self.messages.map {
                    return $0.fullDate
                }
                if let url = self.matrixUseCase.getRoomAvatarUrl(roomId: self.room.room.roomId) {
                    let homeServer = self.config.matrixURL
                    self.room.roomAvatar = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
                    self.roomAvatarUrl = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
                }
                self.isOneDayMessages = messagesFullDate.dropFirst().reduce(true) { partialResult, element in
                    return partialResult && element == messagesFullDate.first
                }
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)

		p2pVoiceCallPublisher
			.subscribe(on: RunLoop.main)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				debugPrint("Place_Call: p2pVoiceCallPublisher")
			// TODO: Handle failure case
			guard let self = self,
				  let roomId = self.room.room.roomId else { return }
				self.p2pCallsUseCase.placeVoiceCall(roomId: roomId, contacts: self.chatData.contacts)
				self.updateToggles()
			}.store(in: &subscriptions)

		p2pVideoCallPublisher
			.subscribe(on: RunLoop.main)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				debugPrint("Place_Call: p2pVideoCallPublisher")
				guard let self = self else { return }

				if self.isGroupCall {
                    self.groupCallsUseCase.placeGroupCallInRoom(roomId: self.room.room.roomId)
					return
				}
				// TODO: Handle failure case
				guard let roomId = self.room.room.roomId else { return }
				self.p2pCallsUseCase.placeVideoCall(roomId: roomId, contacts: self.chatData.contacts)
				self.updateToggles()
			}.store(in: &subscriptions)

		groupCallPublisher
			.subscribe(on: RunLoop.main)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				debugPrint("Place_Call: groupCallPublisher")
				guard let self = self else { return }
				self.groupCallsUseCase.placeGroupCallInRoom(roomId: self.room.room.roomId)
				self.updateToggles()
			}.store(in: &subscriptions)

		settings.inProgressCallSubject
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				debugPrint("Place_Call: inProgressCallSubject")
				guard let self = self else { return }
				self.updateToggles()
			}.store(in: &subscriptions)
    }
    
    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func fetchChatData() {
        chatData.title = room.room.summary.displayName ?? ""
        chatData.description = room.room.summary.topic ?? ""
        chatData.isDirect = room.isDirect

        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = self?.room.roomAvatar, let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { self?.chatData.image = UIImage(data: data) }
            }
        }
        

        chatData.media = room.events().wrapped
            .map { $0.getMediaURLs() ?? [] }
            .flatMap { $0 }
            .map {
                MXURL(mxContentURI: $0)?.contentURL(on: config.matrixURL)
            }
            .compactMap { $0 }
        
        matrixUseCase.getRoomMembers(roomId: room.room.roomId) { [weak self] response in
            guard let self = self,
                case let .success(members) = response else { return }
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
            self.chatData.contacts = contacts
            
            self.matrixUseCase.getRoomState(roomId: self.room.room.roomId) { [weak self] response in
                
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
                
                self?.chatData.contacts = items.filter { $0.isAdmin } + items.filter { !$0.isAdmin }
            }
        }
        
        matrixUseCase.getRoomState(roomId: room.room.roomId) { [weak self] result in
            guard let self = self else { return }
            guard case let .success(state) = result else { return }
            self.roomPowerLevels = state.powerLevels
        }
    }

	func react(toEventId eventId: String, emoji: String) {

		guard
			let message = messages.first(where: { $0.id == eventId }),
			message.reactions.contains(where: { $0.emoji == emoji && $0.isFromCurrentUser == true }) == false
		else {
			return
		}

		matrixUseCase.react(eventId: eventId, roomId: room.room.roomId, emoji: emoji)
	}

	func joinGroupCall(event: RoomMessage) {

		if let mxEvent = room.events().renderableEvents.first(where: { renderableEvent in
			event.eventId == renderableEvent.eventId
		}) {
            self.groupCallsUseCase.joinGroupCallInRoom(
                eventId: mxEvent.eventId,
                roomId: mxEvent.roomId
            )
		} else if let mxRoom = matrixUseCase.rooms.first(where: { $0.room.id == self.room.id }),
			let mxEvent = mxRoom.eventCache.first(where: { cachedEvent in
			cachedEvent.eventId == event.eventId
		}) {
            self.groupCallsUseCase.joinGroupCallInRoom(
                eventId: mxEvent.eventId,
                roomId: mxEvent.roomId
            )
		}
	}
    
    func markAllReaded() {
        matrixUseCase.markAllAsRead(roomId: self.room.room.roomId)
    }
}

// MARK: - Chat Events

extension ChatRoomViewModel {

    // MARK: - Internal Methods

	func makeChatEventView(event: RoomMessage) -> AnyView {
		componentsFactory.makeChatEventView(event: event, viewModel: self)
	}
}
