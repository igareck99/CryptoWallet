import Combine
import UIKit
import MatrixSDK

// MARK: - ChatRoomViewModel
// swiftlint:disable all
final class ChatRoomViewModel: ObservableObject {
    // MARK: - Internal Properties

    weak var delegate: ChatRoomSceneDelegate?

    @Published var chatData = ChatData()
    @Published var saveData = false
    @Published var inputText = ""
    @Published var attachAction: AttachAction?
    @Published var groupAction: GroupAction?
    @Published var translateAction: TranslateAction?

    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var emojiStorage: [ReactionStorage] = []
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published private(set) var userMessage: Message?
    @Published private(set) var room: AuraRoom
    @Published var messages: [RoomMessage] = []
    @Published var translatedMessages: [RoomMessage] = []
    @Published var showPhotoLibrary = false
    @Published var showDocuments = false
    @Published var showContacts = false
    @Published var showTranslate = false
    @Published var showTranslateMenu = false
    @Published var selectedImage: UIImage?
    @Published var pickedImage: UIImage?
    @Published var pickedContact: Contact?
    @Published private var lastLocation: Location?
    @Published var cameraFrame: CGImage?

	var p2pVoiceCallPublisher = ObservableObjectPublisher()
	var isVoiceCallAvailable: Bool {
		let isCallAvailable = availabilityFacade.isCallAvailable
		let isP2PChat = room.room.summary.membersCount.joined == 2
		return isCallAvailable && isP2PChat
	}

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keyboardObserver = KeyboardObserver()
    private let locationManager = LocationManager()
	private let p2pCallsUseCase: P2PCallUseCaseProtocol
	private let availabilityFacade: ChatRoomTogglesFacadeProtocol

    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var translateManager: TranslateManager


    //swiftlint:disable redundant_optional_initialization
    var toggleFacade: MainFlowTogglesFacadeProtocol
    
    // MARK: - Lifecycle

    init(
		room: AuraRoom,
		p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared,
		availabilityFacade: ChatRoomTogglesFacadeProtocol = ChatRoomViewModelAssembly.build(), 
        toggleFacade: MainFlowTogglesFacadeProtocol
	) {
        self.room = room
		self.p2pCallsUseCase = p2pCallsUseCase
		self.availabilityFacade = availabilityFacade
        self.toggleFacade = toggleFacade
        
        bindInput()
        bindOutput()

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
    }

    // MARK: - Internal Methods

    func send(_ event: ChatRoomFlow.Event) {
        eventSubject.send(event)
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
            return translatedMessages.next(item: item)
        } else {
            return messages.previous(item: item)
        }
    }

    func fromCurrentSender(_ userId: String) -> Bool {
		matrixUseCase.fromCurrentSender(userId)
    }
    
    func translateMessagesTo(languageCode: String) {
        showTranslateMenu = false
        for message in self.messages {
            self.translateTo(languageCode: languageCode, message: message)
        }
    }
    
    func isTranslating() -> Bool {
        return translateManager.isActive
    }
    
    func translateTo(languageCode: String, message: RoomMessage) {
        var message = message
        switch message.type {
        case let .text(text):
            translateManager.detect(text) { (locales, error) in
                guard let locales = locales, error == nil else {
                    self.translateManager.isActive = false
                    return
                }
                self.translateManager.isActive = true
                
                
                // Language check
                if Locale.current.languageCode != nil {
                    DispatchQueue.main.async {
                        self.translatedMessages.removeAll()
                    }
                                                            
                    self.translateManager.translate(text, locales[0].language, languageCode, "text", "base") { (translate , error) in
                        DispatchQueue.main.async {
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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    _ = self?.matrixUseCase.rooms
                    self?.room.markAllAsRead()
                    self?.matrixUseCase.objectChangePublisher.send()
                case .onNextScene:
                    ()
                case let .onSendText(text):
                    self?.inputText = ""
                    self?.room.sendText(text)
                    self?.matrixUseCase.objectChangePublisher.send()
                    self?.fetchChatData()
                case let .onSendImage(image):
                    self?.inputText = ""
                    self?.room.sendImage(image)
                    self?.matrixUseCase.objectChangePublisher.send()
                case let .onSendFile(url):
                    self?.inputText = ""
                    self?.room.sendFile(url)
                    self?.matrixUseCase.objectChangePublisher.send()
                case let .onSendContact(contact):
                    self?.room.sendContact(contact)
                    self?.matrixUseCase.objectChangePublisher.send()
                case .onJoinRoom:
                    guard let roomId = self?.room.room.roomId else { return }
                    self?.matrixUseCase.joinRoom(roomId: roomId) { _ in
                        self?.room.markAllAsRead()
                    }
                case let .onReply(text, eventId):
                    self?.room.reply(text: text, eventId: eventId)
                    self?.matrixUseCase.objectChangePublisher.send()
                    self?.fetchChatData()
                case let .onDelete(eventId):
                    self?.room.removeOutgoingMessage(eventId)
                    self?.room.redact(eventId: eventId, reason: nil)
                    self?.matrixUseCase.objectChangePublisher.send()
                case .onAddReaction(let messageId, let reactionId):
                        guard
                            let index = self?.messages.firstIndex(where: { $0.id == messageId }),
                            let emoji = self?.emojiStorage.first(where: { $0.id == reactionId })?.emoji
                        else {
                            return
                        }

                        if self?.messages[index].reactions.contains(where: { $0.id == reactionId }) == false {
                            self?.messages[index].reactions.append(
                                .init(id: reactionId, sender: "", timestamp: Date(), emoji: emoji)
                            )
                        }
                case .onDeleteReaction(let messageId, let reactionId):
                    guard let index = self?.messages.firstIndex(where: { $0.id == messageId }) else { return }
                    self?.messages[index].reactions.removeAll(where: { $0.id == reactionId })
                    self?.matrixUseCase.objectChangePublisher.send()
                }
            }
            .store(in: &subscriptions)

        $attachAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .location:
                    if let location = self?.locationManager.getUserLocation() {
                        let message = RoomMessage(
                            id: UUID().uuidString,
                            type: .location(location),
                            shortDate: Date().hoursAndMinutes,
                            fullDate: Date().dayAndMonthAndYear,
                            isCurrentUser: true,
                            isReply: false,
                            name: "",
                            avatar: nil
                        )
                        self?.messages.append(message)
                    } else {
                        do {
                            try self?.locationManager.requestLocationAccess()
                        } catch {
                            self?.locationManager.openAppSettings()
                        }
                    }
                case .media:
                    self?.showPhotoLibrary = true
                case .document:
                    self?.showDocuments = true
                case .contact:
                    self?.showContacts = true
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        $groupAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .translate:
                    self?.showTranslate = true
                default:
                    break
                }
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
                    self.translateMessagesTo(languageCode: "it")
                case .english:
                    self.translateMessagesTo(languageCode: "en")
                case .spanish:
                    self.translateMessagesTo(languageCode: "es")
                case .french:
                    self.translateMessagesTo(languageCode: "fr")
                case .arabic:
                    self.translateMessagesTo(languageCode: "ar")
                case .german:
                    self.translateMessagesTo(languageCode: "de")
                case .chinese:
                        self.translateMessagesTo(languageCode: "zh-CN")
                }
            }
            .store(in: &subscriptions)
        
        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onSendImage(image))
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
                guard let contact = contact else { return }
                self?.send(.onSendContact(contact))
            }
            .store(in: &subscriptions)

        locationManager.$lastLocation
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastLocation, on: self)
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
                    self?.matrixUseCase.uploadData(data: data, for: room) { [weak self] url in
                        guard let url = url else { return }
                        room.setAvatar(url: url) { _ in
                            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                            self?.room.roomAvatar = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
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
                self.messages = room.events().renderableEvents
                    .map {
                        debugPrint("Events()", self.messages)
                        var message = $0.message(self.fromCurrentSender($0.sender))
                        message?.eventId = $0.eventId
                        var user: MXUser?
                        if !$0.userId.isEmpty {
                            user = self.matrixUseCase.getUser($0.userId)
                        } else {
                            user = self.matrixUseCase.getUser($0.sender)
                        }
                        message?.name = user?.displayname ?? ""
                        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                        message?.avatar = MXURL(mxContentURI: user?.avatarUrl ?? "")?.contentURL(on: homeServer)
                        return message
                    }
                    .reversed()
                    .compactMap { $0 }
            }
            .store(in: &subscriptions)

		p2pVoiceCallPublisher
			.subscribe(on: RunLoop.main)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				debugPrint("Place_Call: publisher")
			// TODO: Handle failure case
			guard let roomId = self?.room.room.roomId else { return }
			self?.p2pCallsUseCase.placeVoiceCall(roomId: roomId)
			}.store(in: &subscriptions)
    }
    
    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func fetchChatData() {
        chatData.title = room.room.summary.displayname ?? ""
        chatData.description = room.room.summary.topic ?? ""
        chatData.isDirect = room.isDirect

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let url = self?.room.roomAvatar, let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { self?.chatData.image = UIImage(data: data) }
            }
        }

        chatData.media = room.events().wrapped
            .map { $0.getMediaURLs() ?? [] }
            .flatMap { $0 }
            .map {
                let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                return MXURL(mxContentURI: $0)?.contentURL(on: homeServer)
            }
            .compactMap { $0 }

        room.room.members { [weak self] response in
            switch response {
            case let .success(members):
                if let members = members {
                    let contacts: [Contact] = members.members.map {
                        var contact = Contact(
                            mxId: $0.userId ?? "",
                            avatar: nil,
                            name: $0.displayname ?? "",
                            status: "Привет, теперь я в Aura"
                        )
                        if let avatar = $0.avatarUrl {
                            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                            contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
                        }
                        return contact
                    }

                    self?.chatData.contacts = contacts

                    self?.room.room.state { response in
                        let ids = response?.powerLevels?.users.keys
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
            default:
                ()
            }
        }
    }
}

extension ChatRoomViewModel {
        
}
