import SwiftUI
import Foundation


protocol WalletAdressScanerResourcable {
    static var qrCodeTitle: String { get }
    
}

enum WalletAdressScanerResources: WalletAdressScanerResourcable {
    static var qrCodeTitle: String {
        R.string.localizable.qrCodeTitle()
    }
}
