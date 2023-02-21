import Foundation

enum Stand: String, RawInitializable {
    case dev, qa, prod
}

enum ApiVersion: String, RawInitializable {
    case v0
}

enum ConfigTypes: String, RawInitializable {
    case debug = "DebugUrlConfig"
    case release = "ReleaseUrlConfig"
}

enum PlistKey {

    case appVersion
    case buildNumber
    case apiURL
    case jitsiURL
    case matrixURL
    case apiVersion
    case apiStand

    var value: String {
        switch self {
        case .appVersion:
            return "CFBundleShortVersionString"
        case .buildNumber:
            return "CFBundleVersion"
        case .apiURL:
            return UrlsConfig.CodingKeys.apiUrl.rawValue
        case .matrixURL:
            return UrlsConfig.CodingKeys.matrixUrl.rawValue
        case .jitsiURL:
            return UrlsConfig.CodingKeys.jitsiMeet.rawValue
        case .apiVersion:
            return UrlsConfig.CodingKeys.apiVersion.rawValue
        case .apiStand:
            return "API Stand"
        }
    }
}
