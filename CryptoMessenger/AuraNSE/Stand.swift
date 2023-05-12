import Foundation

enum Stand: String, Codable, RawInitializable {
    case dev, qa, prod
}

enum ApiVersion: String, RawInitializable {
    case v0
}

enum ConfigTypes: String, RawInitializable {
    case debug = "DebugUrlConfig"
    case release = "ReleaseUrlConfig"
}

enum NetType: String {
    case mainnet
    case testnet
}

enum PlistKey {

    case appVersion
    case buildNumber

    var value: String {
        switch self {
        case .appVersion:
            return "CFBundleShortVersionString"
        case .buildNumber:
            return "CFBundleVersion"
        }
    }
}
