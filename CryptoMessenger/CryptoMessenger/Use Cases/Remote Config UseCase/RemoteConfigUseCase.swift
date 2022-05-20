import Foundation

protocol RemoteConfigUseCaseProtocol {
	var configState: RemoteConfigUseCase.ConfigStates { get }

	func remoteConfigModule(forKey key: RemoteConfigValues) -> RemoteConfigModule?
}

final class RemoteConfigUseCase {

    enum ConfigStates {
        case actual
        case notUpdated
        case updating
    }

	static let shared: RemoteConfigUseCaseProtocol = RemoteConfigUseCaseAssembly.build()

    let firebaseService: RemoteConfigServiceProtocol
    var configState: ConfigStates = .notUpdated

    init(firebaseService: RemoteConfigServiceProtocol) {
        self.firebaseService = firebaseService
		activateConfig()
    }

    private func activateConfig() {
        firebaseService.setupFirebaseRemoteSettings()
        updateConfig()
    }
}

extension RemoteConfigUseCase: RemoteConfigUseCaseProtocol {
    func remoteConfigModule(forKey key: RemoteConfigValues) -> RemoteConfigModule? {
        firebaseService.remoteConfigModule(forKey: key)
    }

    func updateConfig() {
        configState = .updating
        firebaseService.fetchRemoteConfig { [weak self] _ in
			self?.configState = .actual
			debugPrint("RemoteConfig: .configDidUpdate Notification")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .configDidUpdate, object: nil)
            }
        }
    }
}
