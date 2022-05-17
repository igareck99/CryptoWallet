import Firebase

final class FirebaseRemoteConfigService {

	private let remoteConfigFactory: RemoteConfigFactoryProtocol
	private var remoteConfiguration: RemoteConfig {
		FirebaseRemoteConfig.RemoteConfig.remoteConfig()
	}

    init(
		remoteConfigFactory: RemoteConfigFactoryProtocol
	) {
		self.remoteConfigFactory = remoteConfigFactory
    }
}

// MARK: - RemoteConfigServiceProtocol

extension FirebaseRemoteConfigService: RemoteConfigServiceProtocol {

	func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
		remoteConfiguration.fetchAndActivate { fetchStatus, error in
			debugPrint("RemoteConfig: Status: \(fetchStatus), Error: \(String(describing: error))")
			completion(fetchStatus != .error)
		}
	}

	func remoteConfigModule(forKey key: RemoteConfigValues) -> RemoteConfigModule? {
		let remoteConfigData = remoteConfiguration.configValue(forKey: key.rawValue).dataValue
		let featureModule = remoteConfigFactory.makeModule(from: remoteConfigData)
		return featureModule
	}

    func setupFirebaseRemoteSettings() {
        FirebaseApp.configure()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
		remoteConfiguration.configSettings = settings
		remoteConfiguration.setDefaults(fromPlist: "GoogleService-Info")
		remoteConfiguration.fetch { [weak self] status, error -> Void in
            if status == .success {
                debugPrint("RemoteConfig: Config fetched")
                self?.remoteConfiguration.activate { changed, error in
                    debugPrint("RemoteConfig: changed: \(changed) error: \(error.debugDescription)")
                }
            } else {
				debugPrint("RemoteConfig: Fetched error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
