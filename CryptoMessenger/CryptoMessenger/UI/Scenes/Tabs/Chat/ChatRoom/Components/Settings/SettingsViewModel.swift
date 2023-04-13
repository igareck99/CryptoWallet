import Foundation
import Combine

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {

    // MARK: - Internal Properties

    var room: AuraRoom
    weak var delegate: SettingsSceneDelegate?
    @Published var topActions: [SettingsAction] = [.media, .notifications, .admins]
    @Published var bottomActions: [SettingsAction] = [.share, .exit, .complain]

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SettingsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SettingsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(room: AuraRoom) {
        self.room = room
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Internal Methods

    func send(_ event: SettingsFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    ()
                case let .onFriendProfile(userId: userId):
                    self?.delegate?.handleNextScene(.friendProfile(userId))
                case .onMedia:
                    guard let auraRoom = self?.room else { return }
                    self?.delegate?.handleNextScene(.channelMedia(auraRoom))
                }
            }
            .store(in: &subscriptions)
    }
}
