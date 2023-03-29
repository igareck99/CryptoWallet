import Foundation
import Combine

// MARK: - NotificationSettingsViewModel

final class NotificationSettingsViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: NotificationSettingsSceneDelegate?
    @Published var isNotificationMessages = false
    @Published var isNotificationGroup = false
    @Published var isNotificationSettings = false
    @Published var isNotificationsReset = false
    @Published var messageNotification = NotificationSettings(item: NotificationSettingsItems.messageNotification,
                                                              state: false)
    @Published var messagePriority = NotificationSettings(item: NotificationSettingsItems.messagePriority,
                                                          state: false)
    @Published var groupNotification = NotificationSettings(item: NotificationSettingsItems.groupNotification,
                                                            state: false)
    @Published var groupPriority = NotificationSettings(item: NotificationSettingsItems.groupPriority,
                                                        state: false)
    @Published var parametersMessage = NotificationSettings(item: NotificationSettingsItems.parametersMessage,
                                                            state: false)
    @Published var parametersCalls = NotificationSettings(item: NotificationSettingsItems.parametersCalls,
                                                          state: false)
    let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
    let sources: NotificationsSettingsResourcable.Type = NotificationsSettingsResources.self

    // MARK: - Private Properties

    private var pushNotification: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(userSettings: UserCredentialsStorage & UserFlowsStorage,
         pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared) {
        self.pushNotification = pushNotification
        self.userSettings = userSettings
        fetchRemoteConfig()
        fetchData()
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Private Methods

    private func bindInput() {
        $messageNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.updateUserDefaults(value.state)
            }
            .store(in: &subscriptions)
    }

    private func fetchRemoteConfig() {
        isNotificationMessages = remoteConfigUseCase.isV1NotificationMessages
        isNotificationGroup = remoteConfigUseCase.isV1NotificationGroup
        isNotificationSettings = remoteConfigUseCase.isV1NotificationSettings
        isNotificationsReset = remoteConfigUseCase.isV1NotificationsReset
    }

    private func updateUserDefaults(_ value: Bool) {
        userSettings.isRoomNotificationsEnable = value
    }

    private func fetchData() {
        messageNotification.state = userSettings.isRoomNotificationsEnable
    }
}
