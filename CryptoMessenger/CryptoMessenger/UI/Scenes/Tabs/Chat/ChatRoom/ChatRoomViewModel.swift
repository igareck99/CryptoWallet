import Combine
import UIKit

// MARK: - ChatRoomViewModel

final class ChatRoomViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatRoomSceneDelegate?

    @Published var inputText: String = ""
    @Published var action: Action?
    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var messages: [RoomMessage] = []
    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    @Published private(set) var userMessage: Message?
    @Published var showPhotoLibrary = false
    @Published var selectedImage: UIImage?

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
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
                    print("Next scene")
                case let .onSend(type):
                    self?.inputText = ""
                    self?.messages.append(.init(type: type, date: "00:33", isCurrentUser: true))
                }
            }
            .store(in: &subscriptions)

        $action
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

        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.messages.append(.init(type: .image(image), date: "00:33", isCurrentUser: true))
            }
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
        type: .location((lat: 59.939099, long: 30.315877)),
        date: "00:31",
        isCurrentUser: true
    ),
    .init(
        type: .text("Okе, но ты там долго не сиди. Завтра демо:)"),
        date: "00:32",
        isCurrentUser: false
    ),
    .init(
        type: .text("До завтра"),
        date: "00:32",
        isCurrentUser: true
    )
]

extension Array where Element: Equatable {
    func next(item: Element) -> Element? {
        if let index = firstIndex(of: item), index + 1 <= count {
            return index + 1 == count ? self[0] : self[index + 1]
        }
        return nil
    }

    func previous(item: Element) -> Element? {
        if let index = firstIndex(of: item), index >= 0 {
            return index == 0 ? last : self[index - 1]
        }
        return nil
    }
}
