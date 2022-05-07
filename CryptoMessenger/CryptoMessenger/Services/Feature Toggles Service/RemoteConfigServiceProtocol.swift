import Foundation

protocol RemoteConfigServiceProtocol: AnyObject {

	func fetchRemoteConfig(completion: (Bool) -> Void)

	func remoteConfig(forKey key: RemoteFirebaseConfigValue) -> RemoteConfigModule?

    func setupFirebaseRemoteSettings()
}
