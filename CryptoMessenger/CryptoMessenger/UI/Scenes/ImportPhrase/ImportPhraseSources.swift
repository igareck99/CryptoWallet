import SwiftUI

// swiftlint: disable: all
// MARK: - ImportPhraseResourcable

protocol ImportPhraseResourcable {
    
    static var phraseManagerSuccessPhrase: String { get }
    
    static var chatSettingsReserveCopy: String { get }
    
    static var phraseManagerWriteAndRemember: String { get }
    
    static var phraseManagerLetsCheck: String { get }
    
    static var phraseManagerWrongOrder: String { get }
    
    static var phraseManagerWhatIsSecretPhrase: String { get }
    
    static var phraseManagerRememberLater: String { get }
    
    static var phraseManagerTapToSee: String { get }
    
    static var phraseManagerWatch: String { get }
    
    static var phraseManagerISavePhrase: String { get }
    
    static var phraseManagerComplete: String { get }
    
    static var walletManagerTitle: String { get }
    
    static var walletManagerSecretPhrase: String { get }
    
    static var walletManagerWallets: String { get }
    
    static var walletManagerKeyManager: String { get }
    
    static var walletManagerAddDeleteKeys: String { get }
    
    static var lock: Image { get }
    
    static var grayArrow: Image { get }
}

// MARK: - ImportPhraseResourcable(ImportPhraseResourcable)

enum ImportPhraseResources: ImportPhraseResourcable {
    
    
    static var phraseManagerSuccessPhrase: String {
        R.string.localizable.phraseManagerSuccessPhrase()
    }
    
    static var phraseManagerWriteAndRemember: String {
        R.string.localizable.phraseManagerWriteAndRemember()
    }
    
    static var phraseManagerLetsCheck: String {
        R.string.localizable.phraseManagerLetsCheck()
    }
    
    static var phraseManagerWrongOrder: String {
        R.string.localizable.phraseManagerWrongOrder()
    }
    
    static var phraseManagerWhatIsSecretPhrase: String {
        R.string.localizable.phraseManagerWhatIsSecretPhrase()
    }
    
    static var phraseManagerRememberLater: String {
        R.string.localizable.phraseManagerRememberLater()
    }
    
    static var phraseManagerTapToSee: String {
        R.string.localizable.phraseManagerTapToSee()
    }
    
    static var phraseManagerWatch: String {
        R.string.localizable.phraseManagerWatch()
    }
    
    static var phraseManagerISavePhrase: String {
        R.string.localizable.phraseManagerISavePhrase()
    }
    
    static var phraseManagerComplete: String {
        R.string.localizable.phraseManagerComplete()
    }
    
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
    
    static var lock: Image {
        R.image.keyManager.lock.image
    }
    
    static var grayArrow: Image {
        R.image.additionalMenu.grayArrow.image
    }
}
