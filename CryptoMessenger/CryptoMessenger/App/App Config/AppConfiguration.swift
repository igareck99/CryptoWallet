import Foundation
import UIKit.UIDevice

protocol ConfigType {
    var stand: Stand { get }

    var cryptoWallet: String { get }
    var cryptoWalletURL: URL { get }

    var jitsiMeetURL: URL { get }
    var jitsiMeetString: String { get }

    var matrixURL: URL { get }
    var apiURL: URL { get }
    var apiUrlString: String { get }

    var apiVersion: ApiVersion { get }
    var apiVersionString: String { get }

    var appVersion: String { get }
    var deviceName: String { get }
    var os: String { get }
    var buildNumber: String { get }
    var locale: Locale { get }
}

final class Configuration: ConfigType {

    let os: String
    let deviceName: String
    let deviceId: String
    let appVersion: String
    let buildNumber: String
    let locale: Locale

    let stand: Stand
    var apiVersionString: String {
        apiVersion.rawValue
    }

    var apiVersion: ApiVersion {
        ApiVersion(currentConfig.apiVersion)
    }

    var cryptoWallet: String {
        currentConfig.cryptoWallet
    }

    var cryptoWalletURL: URL {
        currentConfig.cryptoWallet.asURL()
    }

    var apiURL: URL {
        currentConfig.apiUrl.asURL()
    }

    var apiUrlString: String {
        currentConfig.apiUrl
    }

    var matrixURL: URL {
        currentConfig.matrixUrl.asURL()
    }

    var jitsiMeetURL: URL {
        currentConfig.jitsiMeet.asURL()
    }

    var jitsiMeetString: String {
        currentConfig.jitsiMeet
    }

    private var currentConfig: UrlsConfig {
        if stand == .dev {
            return debugConfig
        } else {
            return releaseConfig
        }
    }

    private var debugConfig: UrlsConfig = .defaultDebug
    private var releaseConfig: UrlsConfig = .defaultRelease
    private let bundle: Bundle
    private let parser: Parsable.Type

    static var infoDictionary: [String: Any] { Bundle.main.info }
    static let shared: ConfigType = Configuration()

    required init(
        bundle: Bundle = .main,
        locale: Locale = .current,
        parser: Parsable.Type = Parser.self
    ) {
        self.bundle = bundle
        self.locale = locale
        self.parser = parser

        let os = ProcessInfo().operatingSystemVersion
        self.os = String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        self.deviceName = UIDevice.current.name
        self.deviceId = UUID().uuidString
        self.appVersion = bundle.object(for: .appVersion)
        self.buildNumber = bundle.object(for: .buildNumber)
        self.stand = Stand(bundle.object(for: .apiStand))

        self.readConfig()
    }

    private func readConfig() {

        if let dictionary = bundle.info[ConfigTypes.debug.rawValue] as? [String: Any],
           let config = parser.parse(dictionary: dictionary, to: UrlsConfig.self) {
            debugConfig = config
        }

        if let dictionary = bundle.info[ConfigTypes.release.rawValue] as? [String: Any],
           let config = parser.parse(dictionary: dictionary, to: UrlsConfig.self) {
            releaseConfig = config
        }
    }
}
