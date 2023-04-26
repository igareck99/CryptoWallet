import Foundation
import Combine

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Internal Properties
    
    var room: AuraRoom
    weak var delegate: SettingsSceneDelegate?
    @Published var topActions: [SettingsAction] = [.media, .notifications, .admins]
    @Published var bottomActions: [SettingsAction] = [.share, .exit, .complain]
    @Published var isLeaveRoom = false
    @Published var isEnabled = false
    
    // MARK: - Private Properties
    
    private let eventSubject = PassthroughSubject<SettingsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SettingsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    private let pushNotifications: PushNotificationsServiceProtocol
    
    // MARK: - Lifecycle
    
    init(room: AuraRoom,
         pushNotifications: PushNotificationsServiceProtocol = PushNotificationsService.shared) {
        self.room = room
        self.pushNotifications = pushNotifications
        self.isEnabled = !self.room.room.isMuted
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
                    self?.objectWillChange.send()
                case let .onFriendProfile(userId: userId):
                    self?.delegate?.handleNextScene(.friendProfile(userId))
                case .onMedia:
                    guard let auraRoom = self?.room else { return }
                    self?.delegate?.handleNextScene(.channelMedia(auraRoom))
                case .onLeave:
                    self?.leaveRoom()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private Properties
    
    private func leaveRoom() {
        self.matrixUseCase.leaveRoom(roomId: room.room.roomId, completion: { result in
            switch result {
            case .success(_):
                self.isLeaveRoom = true
                self.objectWillChange.send()
            case .failure(_):
                debugPrint("error while out of room")
            }
        })
    }
    
    func changeNotificationState(_ value: Bool) {
        if value {
            self.pushNotifications.allMessages(room: self.room,
                                               completion: { value in
                if value == .allMessagesOn || value == .isAlreadyEnable {
                    self.isEnabled = true
                    self.objectWillChange.send()
                }
            })
        } else {
            self.pushNotifications.mute(room: self.room) { value in
                if value == .muteOn || value == .isAlreadyMuted {
                    self.isEnabled = false
                    self.objectWillChange.send()
                }
            }
        }
    }
}
