import Foundation

enum RemoteConfigServiceAssembly {
	static func build() -> RemoteConfigServiceProtocol {
		let remoteConfigFactory = RemoteConfigFactory()
		let remoteConfigService = FirebaseRemoteConfigService(remoteConfigFactory: remoteConfigFactory)
		return remoteConfigService
	}
}
