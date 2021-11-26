import Foundation
import UIKit.UIDevice

// MARK: - ConfigType

protocol ConfigType {
    var stand: Stand { get }
    var apiURL: URL { get }
    var apiVersion: ApiVersion { get }
    var matrixURL: URL { get }
    var appVersion: String { get }
    var deviceName: String { get }
    var os: String { get }
    var buildNumber: String { get }
    var locale: Locale { get }
}

// MARK: - RawInitializable

protocol RawInitializable: RawRepresentable where RawValue == String {
    init(_ rawValue: String)
}

// MARK: - RawInitializable ()

extension RawInitializable {
    init(_ raw: String) {
        guard let value = Self.init(rawValue: raw) else {
            fatalError("Failed to init from \(raw)")
        }
        self = value
    }
}

// MARK: - Stand

enum Stand: String, RawInitializable {

    // MARK: - Types

    case dev, qa, prod
}

// MARK: - ApiVersion

enum ApiVersion: String, RawInitializable {

    // MARK: - Types

    case v0
}

// MARK: - Configuration

final class Configuration: ConfigType {

    // MARK: - Internal Properties

    let stand: Stand
    let os: String
    let deviceName: String
    let deviceId: String
    let appVersion: String
    let buildNumber: String
    let apiVersion: ApiVersion
    let locale: Locale
    let apiURL: URL
    let matrixURL: URL

    static var infoDictionary: [String: Any] { Bundle.main.info }
    static var apiString: String { Bundle.main.object(for: .apiURL) }
    static var apiVersion: ApiVersion { .v0 }

    // MARK: - Lifecycle

    required init(bundle: Bundle = .main, locale: Locale = .current) {
        self.locale = locale
        self.appVersion = bundle.object(for: .appVersion)
        self.buildNumber = bundle.object(for: .buildNumber)
        self.apiVersion = ApiVersion(bundle.object(for: .apiVersion))
        let os = ProcessInfo().operatingSystemVersion
        self.os = String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        self.deviceName = UIDevice.current.name
        self.deviceId = UUID().uuidString
        self.stand = Stand(bundle.object(for: .apiStand))
        self.apiURL = bundle.object(for: .apiURL).asURL()
        self.matrixURL = bundle.object(for: .matrixURL).asURL()
    }
}

// MARK: - Bundle ()

extension Bundle {

    // MARK: - Internal Properties

    var info: [String: Any] {
        guard let dict = infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }


    // MARK: - PlistKeys

    enum PlistKey {

        // MARK: - Types

        case appVersion
        case buildNumber
        case apiURL
        case matrixURL
        case apiVersion
        case apiStand

        // MARK: - Internal Properties

        var value: String {
            switch self {
            case .appVersion:
                return "CFBundleShortVersionString"
            case .buildNumber:
                return "CFBundleVersion"
            case .apiURL:
                return "API URL"
            case .matrixURL:
                return "MATRIX URL"
            case .apiVersion:
                return "API Version"
            case .apiStand:
                return "API stand"
            }
        }
    }

    // MARK: - Internal Methods

    func object(for key: PlistKey) -> String {
        guard let string = object(forInfoDictionaryKey: key.value) as? String else {
            fatalError("\(key.value) not set in plist")
        }
        return string
    }
}
