import Foundation

struct RemoteConfigFeature: Codable {
	let versions: [String: Bool]
	let enabled: Bool
	let name: String
}

struct RemoteConfigModule: Codable {
	let features: [String: RemoteConfigFeature]
	let name: String
}

struct RemoteConfigurations: Codable {
	let modules: [String: RemoteConfigModule]
}
