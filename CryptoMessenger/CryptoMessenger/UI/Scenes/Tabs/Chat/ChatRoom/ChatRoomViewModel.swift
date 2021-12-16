import Combine
import UIKit

// MARK: - ChatRoomViewModel

final class ChatRoomViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatRoomSceneDelegate?

    @Published var inputText: String = ""
    @Published var attachAction: AttachAction?
    @Published var quickAction: QuickAction?
    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var messages: [RoomMessage] = []
    @Published private(set) var emojiStorage: [ReactionStorage] = []
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published private(set) var userMessage: Message?
    @Published private(set) var room: AuraRoom
    @Published var showPhotoLibrary = false
    @Published var selectedImage: UIImage?
    @Published private var lastLocation: Location?

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keyboardObserver = KeyboardObserver()
    private let locationManager = LocationManager()

    @Injectable private var mxStore: MatrixStore

    // MARK: - Lifecycle

    init(room: AuraRoom) {
        self.room = room
        messages = room.events().renderableEvents
            .map { $0.message(fromCurrentSender($0.sender)) }
            .reversed()
            .compactMap { $0 }

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
                case let .onSend(type):
                    self?.sendMessage(type)
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
                            isCurrentUser: true
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
                case .contact:
                    let message = RoomMessage(
                        id: UUID().uuidString,
                        type: .contact,
                        shortDate: "00:31",
                        fullDate: "00:31",
                        isCurrentUser: true
                    )
                    self?.messages.append(message)
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        $quickAction
            .receive(on: DispatchQueue.main)
            .sink { action in
                print(action)
            }
            .store(in: &subscriptions)

        locationManager.$lastLocation
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastLocation, on: self)
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func sendMessage(_ type: MessageType) {
        inputText = ""

        switch type {
        case let .text(text):
            room.send(text: text)
        case let .image(image):
            room.sendImage(image: image)
        default:
            break
        }

        messages.insert(
            .init(
                id: UUID().uuidString,
                type: type,
                shortDate: Date().hoursAndMinutes,
                fullDate: Date().dayOfWeekDayAndMonth,
                isCurrentUser: true
            ),
            at: 0
        )

        mxStore.objectWillChange.send()
    }
}

private var mockEmojiStorage: [ReactionStorage] = ["👍", "👎", "😄", "🎉", "❤️", "🚀", "👀"]
    .map { .init(id: UUID().uuidString, emoji: $0) }
