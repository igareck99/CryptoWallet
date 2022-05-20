import Foundation

protocol RemoteConfigFactoryProtocol {

	func makeRemoteConfig(from data: Data) -> RemoteConfigurations?

	func makeModule(from data: Data) -> RemoteConfigModule?

	func makeFeature(from data: Data) -> RemoteConfigFeature?
}

final class RemoteConfigFactory {

	private let parser: Parsable.Type

	init(
		parser: Parsable.Type = Parser.self
	) {
		self.parser = parser
	}
}

// MARK: - RemoteConfigFactoryProtocol

extension RemoteConfigFactory: RemoteConfigFactoryProtocol {

	func makeRemoteConfig(from data: Data) -> RemoteConfigurations? {
		let remoteConfig = parser.parse(data: data, to: RemoteConfigurations.self)
		return remoteConfig
	}

	func makeModule(from data: Data) -> RemoteConfigModule? {
		let featureModule = parser.parse(data: data, to: RemoteConfigModule.self)
		return featureModule
	}

	func makeFeature(from data: Data) -> RemoteConfigFeature? {
		let feature = parser.parse(data: data, to: RemoteConfigFeature.self)
		return feature
	}
}
