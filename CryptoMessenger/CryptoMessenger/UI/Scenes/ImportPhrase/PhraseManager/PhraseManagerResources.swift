import SwiftUI


protocol PhraseManagerResourcable {
    static var phraseManagerSuccessPhrase: String { get }
    static var phraseManagerComplete: String { get }
    static var chatSettingsReserveCopy: String { get }
    static var phraseManagerWriteAndRemember: String { get }
    static var phraseManagerLetsCheck: String { get }
    static var phraseManagerWrongOrder: String { get }
    static var phraseManagerWhatIsSecretPhrase: String { get }
    static var phraseManagerRememberLater: String { get }
    static var phraseManagerTapToSee: String { get }
    static var phraseManagerWatch: String { get }
    static var phraseManagerISavePhrase: String { get }
    
    static var backgroundFodding: Color { get }
    static var background: Color { get }
    static var negativeColor: Color { get }
    static var textBoxBackground: Color { get }
    static var titleColor: Color { get }
    static var buttonBackground: Color { get }
    static var textColor: Color { get }
    static var inactiveButton: Color { get }
    
    static var lock: Image { get }
}


enum PhraseManagerResources: PhraseManagerResourcable {
    static var phraseManagerSuccessPhrase: String {
        R.string.localizable.phraseManagerSuccessPhrase()
    }
    static var phraseManagerComplete: String {
        R.string.localizable.phraseManagerComplete()
    }
    static var chatSettingsReserveCopy: String {
        R.string.localizable.chatSettingsReserveCopy()
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
    
    
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    static var background: Color {
        .white 
    }
    static var negativeColor: Color {
        .spanishCrimson
    }
    static var textBoxBackground: Color {
        .aliceBlue
    }
    static var titleColor: Color {
        .chineseBlack
    }
    static var buttonBackground: Color {
        .dodgerBlue
    }
    static var textColor: Color {
        .romanSilver
    }
    static var inactiveButton: Color {
        .ghostWhite
    }

    
    static var lock: Image {
        R.image.keyManager.lock.image
    }
    
}
