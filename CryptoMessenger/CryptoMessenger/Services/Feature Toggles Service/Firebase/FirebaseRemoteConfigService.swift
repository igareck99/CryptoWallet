import FirebaseRemoteConfig
import Firebase

final class FirebaseRemoteConfigService {

	private var remoteConfig = FirebaseRemoteConfig.RemoteConfig.remoteConfig()
	private let remoteConfigFactory: RemoteConfigFactoryProtocol

    init(
		remoteConfigFactory: RemoteConfigFactoryProtocol
	) {
		self.remoteConfigFactory = remoteConfigFactory
    }
}

// MARK: - RemoteConfigServiceProtocol

extension FirebaseRemoteConfigService: RemoteConfigServiceProtocol {

	func fetchRemoteConfig(completion: (Bool) -> Void) {
		remoteConfig.fetchAndActivate { fetchStatus, error in
			debugPrint("Status: \(fetchStatus), Error: \(String(describing: error))")
		}
	}

	func remoteConfig(forKey key: RemoteFirebaseConfigValue) -> RemoteConfigModule? {
		let remoteConfigData = self.remoteConfig.configValue(forKey: RemoteFirebaseConfigValue.aura.rawValue).dataValue
		let remoteConfig = remoteConfigFactory.makeRemoteConfig(from: remoteConfigData)
		let featureModule = remoteConfig?.modules[key.rawValue]
		return featureModule
	}

    func setupFirebaseRemoteSettings() {
        FirebaseApp.configure()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
        remoteConfig.fetch { [weak self] status, error -> Void in
            if status == .success {
                debugPrint("Config fetched!")
                self?.remoteConfig.activate { changed, error in
                    debugPrint(changed)
                    debugPrint("\(error.debugDescription)")
                }
            } else {
                debugPrint("Config not fetched. Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

// MARK: - RemoteValueKey

enum RemoteValueKey: String {
    case Chat
    case Wallet
}

// MARK: - RemoteFirebaseConfigValue

enum RemoteFirebaseConfigValue: String {

	case aura = "Aura"
	case chat = "Chat"
	case wallet = "Wallet"

	enum Chat: String {
		case groupChat
        case personalChat
    }

	enum Wallet: String {
		case ethereumWallet
    }
}
