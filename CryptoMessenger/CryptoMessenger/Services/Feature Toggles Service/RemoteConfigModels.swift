import Foundation

struct ConfigBody: Codable {
    let enabled: Bool
}

struct RemoteConfigFeature: Codable {

    let config: [String: ConfigBody]
    let enabled: Bool
}

struct RemoteConfigModule: Codable {

    let features: [String: RemoteConfigFeature]
    let moduleName: String
}

struct RemoteConfig: Codable {
	let modules: [String: RemoteConfigModule]
}
