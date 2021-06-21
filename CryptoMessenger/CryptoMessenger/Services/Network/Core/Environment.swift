import Foundation
import UIKit.UIDevice

// MARK: Endpoint

protocol ConfigType {
    var environment: Environment? { get }
    var appVersion: String { get }
    var deviceModel: String { get }
    var os: String { get }
    var buildNumber: String { get }
    var apiVersion: ApiVersion { get }
    var baseURL: URL { get }
    var locale: Locale { get }
}

// MARK: - Environment

enum Environment: String {
    case dev
    case qa
    case prod
}

enum ApiVersion: String {
    case v1
}

// MARK: - EnvironmentConfiguration

final class EnvironmentConfiguration: ConfigType {

    // MARK: - Types

    enum PlistKeys {
        static let baseURL = "Base URL"
        static let apiVersion = "API Version"
        static let environment = "Environment"
    }

    // MARK: - Internal Properties

    let environment: Environment?
    let os: String
    let deviceModel: String
    let appVersion: String
    let buildNumber: String
    let apiVersion: ApiVersion
    let locale: Locale
    let baseURL: URL

    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let baseString: String = {
        guard let rootURLstring = Bundle.main.object(forInfoDictionaryKey: PlistKeys.baseURL) as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return rootURLstring
    }()

    static var apiVersion: ApiVersion { .v1 }

    // MARK: - Lifecycle

    required init(bundle: Bundle = .main, locale: Locale = .current) {
        self.locale = locale

        let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        self.appVersion = appVersion ?? ""

        let buildNumber = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        self.buildNumber = buildNumber ?? ""

        apiVersion = EnvironmentConfiguration.apiVersion

        let os = ProcessInfo().operatingSystemVersion
        self.os = String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)

        deviceModel = UIDevice.current.model

        guard let environment = bundle.object(forInfoDictionaryKey: PlistKeys.environment) as? String else {
            fatalError("Environment not set in plist")
        }
        self.environment = Environment(rawValue: environment)

        guard let baseURL = URL(string: EnvironmentConfiguration.baseString) else {
            fatalError("Base URL convertible failed")
        }
        self.baseURL = baseURL
    }
}
