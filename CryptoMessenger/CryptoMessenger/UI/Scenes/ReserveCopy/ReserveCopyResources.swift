import Foundation

// swiftlint: disable: all

// MARK: - ReserveCopyResourcable

protocol ReserveCopyResourcable {
    
    static var reserveCopy: String { get }
    
    static var generatePhraseCopied: String { get }
    
    static var phraseManagerYourSecretPhrase: String { get }
    
    static var generatePhraseGeneratedDescription: String { get }
    
    static var generatePhraseCopyPhrase: String { get }
}

// MARK: - ReserveCopyResources(ReserveCopySourcable)

enum ReserveCopyResources: ReserveCopyResourcable {
    
    static var reserveCopy: String {
        R.string.localizable.chatSettingsReserveCopy()
    }
    
    static var generatePhraseCopied: String {
        R.string.localizable.generatePhraseCopied()
    }
    
    static var phraseManagerYourSecretPhrase: String {
        R.string.localizable.phraseManagerYourSecretPhrase()
    }
    
    static var generatePhraseGeneratedDescription: String {
        R.string.localizable.generatePhraseGeneratedDescription()
    }
    
    static var generatePhraseCopyPhrase: String {
        R.string.localizable.generatePhraseCopyPhrase()
    }
}
