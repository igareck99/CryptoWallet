import Foundation
import UIKit.UIDevice

protocol ConfigType {
    
    var licensePage: String { get }

    var rulesPage: String { get }

    var deviceName: String { get }

    var appName: String { get }

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
    var os: String { get }
    var buildNumber: String { get }
    var locale: Locale { get }

    var netType: NetType { get }

    var devTeamId: String { get }

    var bundleId: String { get }

    var voipId: String { get }

    var voipIdDebug: String { get }

    var pushId: String { get }

    var pushIdDev: String { get }

    var voipPushesPusherId: String { get }

    var pushesPusherId: String { get }

    var pusherUrl: String { get }

    var keychainAccessGroup: String { get }

    var keychainServiceName: String { get }
}

final class Configuration: ConfigType {

    let os: String
    let deviceId: String
    let appVersion: String
    let buildNumber: String
    let locale: Locale
    let stand: Stand

    var licensePage: String {
        "https://yandex.ru"
    }

    var rulesPage: String {
        "https://developer.apple.com"
    }
    
    var deviceName: String {
        UIDevice.current.name
    }

    var appName: String {
        "AURA Wallet Messenger"
    }

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

    var netType: NetType {
        return stand == .dev ? .testnet : .mainnet
    }

    private var currentConfig: UrlsConfig {
        if stand == .dev {
            return debugConfig
        } else {
            return releaseConfig
        }
    }

    var devTeamId: String {
        Bundle.main.infoDictionary?["DevTeam"] as? String ?? ""
    }

    var bundleId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    var voipId: String {
        bundleId + ".voip"
    }

    var voipIdDebug: String {
        bundleId + ".voip.debug"
    }

    var pushId: String {
        bundleId
    }

    var pushIdDev: String {
        bundleId + ".debug"
    }

    var voipPushesPusherId: String {
        #if DEBUG
        return voipIdDebug
        #else
        return voipId
        #endif
    }

    var pushesPusherId: String {
        #if DEBUG
        return pushIdDev
        #else
        return pushId
        #endif
    }
    
    var pusherUrl: String {
        currentConfig.matrixUrl + "_matrix/push/v1/notify"
    }

    var keychainAccessGroup: String {
        devTeamId + ".ru.aura.app.test.keychain.accessGroup"
    }

    let keychainServiceName = "ru.aura.app.keychain.service"

    private var debugConfig: UrlsConfig = .defaultDebug
    private var releaseConfig: UrlsConfig = .defaultRelease
    private let bundle: Bundle
    private let parser: Parsable.Type

    static var infoDictionary: [String: Any] { Bundle.main.info }
    static let shared: ConfigType = Configuration()

    required init(
        bundle: Bundle = .main,
        locale: Locale = .current,
        parser: Parsable.Type = Parser.self,
        stand: Stand = .prod
    ) {
        self.bundle = bundle
        self.locale = locale
        self.parser = parser

        let os = ProcessInfo().operatingSystemVersion
        self.os = String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        self.deviceId = UUID().uuidString
        self.appVersion = bundle.object(for: .appVersion)
        self.buildNumber = bundle.object(for: .buildNumber)
        self.stand = stand
    }
}
