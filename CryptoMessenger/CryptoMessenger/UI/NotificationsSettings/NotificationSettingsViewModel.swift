import Foundation
import Combine
import MatrixSDK

// MARK: - NotificationSettingsViewModel

final class NotificationSettingsViewModel: ObservableObject {

    // MARK: - Internal Properties

    var coordinator: ProfileCoordinatable?
    @Published var isNotificationDevice = false
    @Published var allMessages = NotificationSettings(item: NotificationSettingsItems.allMessages,
                                                      state: false)
    @Published var mentionsOnly = NotificationSettings(item: NotificationSettingsItems.mentionsOnly,
                                                       state: false)
    @Published var mute = NotificationSettings(item: NotificationSettingsItems.mute,
                                               state: false)
    @Published var userAccount = NotificationSettings(item: NotificationSettingsItems.userAccount,
                                                      state: false)
    @Published var onDevice = NotificationSettings(item: NotificationSettingsItems.onDevice,
                                                   state: false)
    let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
    let sources: NotificationsSettingsResourcable.Type = NotificationsSettingsResources.self

    // MARK: - Private Properties

    private let userSettings: UserFlowsStorage
    private let keychainService: KeychainServiceProtocol
    private let matrixUseCase: MatrixUseCaseProtocol
    private let pushService: MXRoomNotificationSettingsService
    private var subscriptions = Set<AnyCancellable>()
    private var firstUserAccount = false
    private var firstOnDevice = false
    private let config: ConfigType

    // MARK: - Lifecycle

    init(
        userSettings: UserFlowsStorage = UserDefaultsService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        config: ConfigType = Configuration.shared
    ) {
        self.userSettings = userSettings
        self.keychainService = keychainService
        self.matrixUseCase = matrixUseCase
        self.config = config
        self.pushService = MXRoomNotificationSettingsService(roomId: "")
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
        $userAccount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if self.firstUserAccount {
                    if !value.state {
                        self.onDevice.state = false
                    } else {
                        self.onDevice.state = true
                    }
                    self.pushService.notificationsOnAllDevice(value.state)
                } else {
                    self.firstUserAccount = true
                }
            }
            .store(in: &subscriptions)
        $onDevice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                guard let data = keychainService.data(forKey: .pushToken) else { return }
                if self.firstOnDevice {
                    if value.state {
                        self.matrixUseCase.createPusher(pushToken: data) { state in
                            debugPrint("UPDATE PUSHER STATE  \(state)")
                            self.userSettings[.isPushNotificationsEnabled] = true
                        }
                    } else {
                        self.matrixUseCase.deletePusher(
                            appId: self.config.pushesPusherId,
                            pushToken: data
                        ) { state in
                            debugPrint("DELETE PUSHER STATE  \(state)")
                            self.userSettings[.isPushNotificationsEnabled] = false
                        }
                    }
                } else {
                    self.firstOnDevice = true
                }
            }
            .store(in: &subscriptions)
    }

    private func fetchRemoteConfig() {
        isNotificationDevice = remoteConfigUseCase.isV1NotificationDevice
        userAccount.state = pushService.getNotificationsOnAllDeviceState() ?? false
    }

    private func fetchData() {
        onDevice.state = userSettings.bool(forKey: .isPushNotificationsEnabled)
    }
}
