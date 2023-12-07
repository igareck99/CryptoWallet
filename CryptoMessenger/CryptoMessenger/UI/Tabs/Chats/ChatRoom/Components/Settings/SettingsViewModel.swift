import Combine
import MatrixSDK
import SwiftUI

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {

    // MARK: - Internal Properties

    var room: AuraRoom
    var coordinator: ChatsCoordinatable?
    @Published var topActions: [SettingsAction] = [.media, .notifications, .admins]
    @Published var bottomActions: [SettingsAction] = [.share, .exit, .complain]
    @Published var isEnabled = false
    @State private var selectedVideo: URL?
    let resources: SettingsResourcable.Type

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SettingsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SettingsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    private let pushNotifications: PushNotificationsServiceProtocol

    // MARK: - Lifecycle

    init(room: AuraRoom,
         pushNotifications: PushNotificationsServiceProtocol = PushNotificationsService.shared,
         resources: SettingsResourcable.Type = SettingsResources.self
    ) {
        self.resources = resources
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
                case let .onFriendProfile(contact):
                    // MARK: - ?????
                    ()
                    // self?.coordinator?.friendProfile(contact)
                case .onLeave:
                    self?.leaveRoom()
                case let .onAdmin(chatData):
                    guard let coordinator = self?.coordinator else { return }
                    coordinator.adminsView(
                        chatData: chatData,
                        coordinator: coordinator
                    )
                case let .onMembers(chatData):
                    guard let coordinator = self?.coordinator else { return }
                    coordinator.chatMembersView(
                        chatData: chatData,
                        coordinator: coordinator
                    )
                case .onNotifications:
                    guard let roomId = self?.room.room.roomId else { return }
                    self?.coordinator?.notifications(
                        roomId: roomId
                    )
                case let .onImagePicker(image):
                    guard let self = self else { return }
                    self.coordinator?.galleryPickerSheet(sourceType: .photoLibrary,
                                                         galleryContent: .all, onSelectImage: { newImage in
                        if let newImage = newImage {
                            image.wrappedValue = newImage
                        }
                    }, onSelectVideo: { _ in
                    })
                default:
                    break
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private Properties

    private func leaveRoom() {
        self.matrixUseCase.leaveRoom(roomId: room.room.roomId, completion: { result in
            switch result {
            case .success(_):
                self.coordinator?.popToRoot()
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
