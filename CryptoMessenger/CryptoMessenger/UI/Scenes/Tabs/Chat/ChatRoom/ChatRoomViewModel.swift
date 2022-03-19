import Combine
import UIKit

// MARK: - ChatRoomViewModel

final class ChatRoomViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatRoomSceneDelegate?

    @Published var chatData = ChatData()
    @Published var saveData = false
    @Published var inputText = ""
    @Published var attachAction: AttachAction?
    @Published var quickAction: QuickAction?
    @Published var groupAction: GroupAction?
    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var messages: [RoomMessage] = []
    @Published private(set) var emojiStorage: [ReactionStorage] = []
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published private(set) var userMessage: Message?
    @Published private(set) var room: AuraRoom
    @Published var showPhotoLibrary = false
    @Published var showDocuments = false
    @Published var showContacts = false
    @Published var selectedImage: UIImage?
    @Published var pickedImage: UIImage?
    @Published var pickedContact: Contact?
    @Published private var lastLocation: Location?
    @Published var cameraFrame: CGImage?

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keyboardObserver = KeyboardObserver()
    private let locationManager = LocationManager()
    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    private let context = CIContext()

    @Injectable private var mxStore: MatrixStore

    // MARK: - Lifecycle

    init(room: AuraRoom) {
        self.room = room
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
        messages.next(item: item)
    }

    func previous(_ item: RoomMessage) -> RoomMessage? {
        messages.previous(item: item)
    }

    func fromCurrentSender(_ userId: String) -> Bool {
        mxStore.fromCurrentSender(userId)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    _ = self?.mxStore.rooms
                    self?.room.markAllAsRead()
                    self?.mxStore.objectWillChange.send()
                case .onNextScene:
                    ()
                case let .onSendText(text):
                    self?.inputText = ""
                    self?.room.sendText(text)
                    self?.mxStore.objectWillChange.send()
                case let .onSendImage(image):
                    self?.inputText = ""
                    self?.room.sendImage(image)
                    self?.mxStore.objectWillChange.send()
                case let .onSendFile(url):
                    self?.inputText = ""
                    self?.room.sendFile(url)
                    self?.mxStore.objectWillChange.send()
                case let .onSendContact(contact):
                    self?.room.sendContact(contact)
                    self?.mxStore.objectWillChange.send()
                case .onJoinRoom:
                    guard let roomId = self?.room.room.roomId else { return }
                    self?.mxStore.joinRoom(roomId: roomId) { _ in
                        self?.room.markAllAsRead()
                    }
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
                            shortDate: "00:31",
                            fullDate: "00:31",
                            isCurrentUser: true,
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
                    self?.showPhotoLibrary.toggle()
                case .document:
                    self?.showDocuments.toggle()
                case .contact:
                    self?.showContacts.toggle()
                default:
                    break
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

        $quickAction
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &subscriptions)

        locationManager.$lastLocation
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
                    self?.mxStore.uploadData(data: data, for: room) { [weak self] url in
                        guard let url = url else { return }
                        room.setAvatar(url: url) { _ in
                            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                            self?.room.roomAvatar = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
                        }
                    }
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let room = self.mxStore.rooms.first(where: { $0.room.id == self.room.id })
                else {
                    return
                }
                self.messages = room.events().renderableEvents
                    .map {
                        var message = $0.message(self.fromCurrentSender($0.sender))
                        let user = self.mxStore.getUser($0.sender)
                        message?.name = user?.displayname ?? ""
                        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                        message?.avatar = MXURL(mxContentURI: user?.avatarUrl ?? "")?.contentURL(on: homeServer)
                        return message
                    }
                    .reversed()
                    .compactMap { $0 }
            }
            .store(in: &subscriptions)

        // swiftlint:disable:next array_init
//        cameraManager.$error
//          .receive(on: RunLoop.main)
//          .map { $0 }
//          .assign(to: &$error)
//
        frameManager.$current
          .receive(on: RunLoop.main)
          .compactMap { buffer in
            guard let image = CGImage.create(from: buffer) else { return nil }

            let ciImage = CIImage(cgImage: image)
//            if self.comicFilter {
//              ciImage = ciImage.applyingFilter("CIComicEffect")
//            }
            return self.context.createCGImage(ciImage, from: ciImage.extent)
          }
          .assign(to: &$cameraFrame)
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
