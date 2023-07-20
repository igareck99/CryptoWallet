import SwiftUI

// swiftlint: disable: all
// MARK: - ImportPhraseResourcable

protocol ImportPhraseResourcable {
    
    static var chatSettingsReserveCopy: String { get }
    
    static var walletManagerTitle: String { get }
    
    static var walletManagerSecretPhrase: String { get }
    
    static var walletManagerWallets: String { get }
    
    static var walletManagerKeyManager: String { get }
    
    static var walletManagerAddDeleteKeys: String { get }
    
    static var grayArrow: Image { get }
    
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var background: Color { get }
}

// MARK: - ImportPhraseResourcable(ImportPhraseResourcable)

enum ImportPhraseResources: ImportPhraseResourcable {
   
    static var walletManagerTitle: String {
        R.string.localizable.walletManagerTitle()
    }
    
    static var chatSettingsReserveCopy: String {
        R.string.localizable.chatSettingsReserveCopy()
    }
    
    static var walletManagerSecretPhrase: String {
        R.string.localizable.walletManagerSecretPhrase()
    }
    
    static var walletManagerWallets: String {
        R.string.localizable.walletManagerWallets()
    }
    
    static var walletManagerKeyManager: String {
        R.string.localizable.walletManagerKeyManager()
    }
    
    static var walletManagerAddDeleteKeys: String {
        R.string.localizable.walletManagerAddDeleteKeys()
    }
    
    static var grayArrow: Image {
        R.image.additionalMenu.grayArrow.image
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var background: Color {
        .white
    }
    
}
