import Foundation
import UIKit.UIDevice

protocol ConfigType {
    var licensePage: String { get }
    var rulesPage: String { get }
    
    var deviceId: String { get }
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
