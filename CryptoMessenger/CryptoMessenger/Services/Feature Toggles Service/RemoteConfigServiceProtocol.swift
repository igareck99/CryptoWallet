import Foundation

protocol RemoteConfigServiceProtocol: AnyObject {

	func fetchRemoteConfig(completion: @escaping (Bool) -> Void)

	func remoteConfigModule(forKey key: RemoteConfigValues) -> RemoteConfigModule?

    func setupFirebaseRemoteSettings()
}