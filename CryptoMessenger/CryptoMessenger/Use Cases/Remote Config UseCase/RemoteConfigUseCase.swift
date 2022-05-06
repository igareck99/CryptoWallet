import Foundation

protocol RemoteConfigUseCaseProtocol {
    var configState: RemoteConfigUseCase.ConfigStates { get }
    func remoteConfig(forKey key: RemoteFirebaseConfigValue) -> RemoteConfigModule?
    func start()
}

final class RemoteConfigUseCase {

    enum ConfigStates {
        case actual
        case notUpdated
        case updating
    }

    let firebaseService: RemoteConfigServiceProtocol
    var configState: ConfigStates = .notUpdated

    init(firebaseService: RemoteConfigServiceProtocol) {
        self.firebaseService = firebaseService
    }

    private func activateConfig() {
        firebaseService.setupFirebaseRemoteSettings()
        updateConfig()
    }
}

extension RemoteConfigUseCase: RemoteConfigUseCaseProtocol {
    func remoteConfig(forKey key: RemoteFirebaseConfigValue) -> RemoteConfigModule? {
        firebaseService.remoteConfig(forKey: key)
    }

    func start() {
        activateConfig()
    }

    func updateConfig() {
        configState = .updating
        firebaseService.fetchRemoteConfig { _ in
            configState = .actual
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .configDidUpdate, object: nil)
            }
        }
    }
}
