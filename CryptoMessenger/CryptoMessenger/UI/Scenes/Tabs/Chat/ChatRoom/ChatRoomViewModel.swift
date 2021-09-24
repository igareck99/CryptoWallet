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
    @Published var showPhotoLibrary = false
    @Published var selectedImage: UIImage?
    @Published private var lastLocation: Location?

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keyboardObserver = KeyboardObserver()
    private let locationManager = LocationManager()

    // MARK: - Lifecycle

    init(userMessage: Message) {
        bindInput()
        bindOutput()

        sortedMessages[1].reactions = [
            .init(
                id: mockEmojiStorage[5].id,
                sender: "",
                timestamp: Date(),
                emoji: "🚀"
            )
        ]

        sortedMessages[sortedMessages.count - 3].reactions = [
            .init(
                id: mockEmojiStorage[0].id,
                sender: "",
                timestamp: Date(),
                emoji: "👍"
            ),
            .init(
                id: mockEmojiStorage[2].id,
                sender: "",
                timestamp: Date(),
                emoji: "😄"
            )
        ]

        sortedMessages[sortedMessages.count - 2].reactions = [
            .init(
                id: mockEmojiStorage[4].id,
                sender: "",
                timestamp: Date(),
                emoji: "❤️"
            )
        ]

        self.userMessage = userMessage
        self.messages = sortedMessages

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

        if !mockEmojiStorage.contains(where: { $0.isLastButton }) {
            mockEmojiStorage.append(.init(id: UUID().uuidString, emoji: "", isLastButton: true))
        }

        emojiStorage = mockEmojiStorage
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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    break
                case .onNextScene:
                    print("Next scene")
                case let .onSend(type):
                    self?.inputText = ""
                    self?.messages.append(.init(type: type, date: "00:33", isCurrentUser: true))
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
                            type: .location(location),
                            date: "00:31",
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

        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.messages.append(.init(type: .image(image), date: "00:33", isCurrentUser: true))
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
}

private var sortedMessages: [RoomMessage] = [
    .init(
        type: .text("Привет, трудяга!:)"),
        date: "00:30",
        isCurrentUser: false
    ),
    .init(
        type: .text("Хей, коллега👋🏼"),
        date: "00:31",
        isCurrentUser: true
    ),
    .init(
        type: .text("Ты опять по ночам не спишь? Пилишь проект AURA?)"),
        date: "00:31",
        isCurrentUser: false
    ),
    .init(
        type: .text("Ну, да! Классный проект!☺️"),
        date: "00:31",
        isCurrentUser: true
    ),
    .init(
        type: .text("Okе, но ты там долго не сиди. Завтра демо:)"),
        date: "00:32",
        isCurrentUser: false
    ),
    .init(
        type: .text("Кстати, я фанат Басты!)"),
        date: "00:32",
        isCurrentUser: false
    ),
    .init(
        type: .image(R.image.chat.mockFeed3()!),
        date: "00:32",
        isCurrentUser: false
    ),
    .init(
        type: .text("Сочувствую!)"),
        date: "00:32",
        isCurrentUser: true
    )
]

private var mockEmojiStorage: [ReactionStorage] = ["👍", "👎", "😄", "🎉", "❤️", "🚀", "👀"]
    .map { .init(id: UUID().uuidString, emoji: $0) }
