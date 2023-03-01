import SwiftUI

// swiftlint: disable: all

// MARK: - GeneratePhraseResourcable

protocol GeneratePhraseResourcable {
    
    static var generatePhraseCopied: String { get }
    
    static var generatePhraseTitle: String { get }
    
    static var generatePhraseDescription: String { get }
    
    static var generatePhraseQuestion: String { get }
    
    static var generatePhraseWarning: String { get }
    
    static var generatePhraseWarningDescription: String { get }
    
    static var generatePhraseImportKey: String { get }
    
    static var generatePhraseCopyPhrase: String { get }
    
    static var generatePhraseGeneratedTitle: String { get }
    
    static var keyGenerationCreateButton: String { get }
    
    static var phraseManagerYourSecretPhrase: String { get }
    
    static var generatePhraseGeneratedDescription: String { get }
    
    static var puzzle: Image { get }
    
    static var person: Image { get }
}

// MARK: - GeneratePhraseResources(GeneratePhraseResourcable)

enum GeneratePhraseResources: GeneratePhraseResourcable {
    
    static var generatePhraseCopied: String {
        R.string.localizable.generatePhraseCopied()
    }
    
    static var generatePhraseTitle: String {
        R.string.localizable.generatePhraseTitle()
    }
    
    static var generatePhraseDescription: String {
        R.string.localizable.generatePhraseDescription()
    }
    
    static var generatePhraseQuestion: String {
        R.string.localizable.generatePhraseQuestion()
    }
    
    static var generatePhraseWarning: String {
        R.string.localizable.generatePhraseWarning()
    }
    
    static var generatePhraseWarningDescription: String {
        R.string.localizable.generatePhraseWarningDescription()
    }
    
    static var generatePhraseImportKey: String {
        R.string.localizable.generatePhraseImportKey()
    }
    
    static var generatePhraseCopyPhrase: String {
        R.string.localizable.generatePhraseCopyPhrase()
    }
    
    static var keyGenerationCreateButton: String {
        R.string.localizable.keyGenerationCreateButton()
    }
    
    static var generatePhraseGeneratedTitle: String {
        R.string.localizable.generatePhraseGeneratedTitle()
    }
    
    static var phraseManagerYourSecretPhrase: String {
        R.string.localizable.phraseManagerYourSecretPhrase()
    }
    
    static var generatePhraseGeneratedDescription: String {
        R.string.localizable.generatePhraseGeneratedDescription()
    }
    
    static var puzzle: Image {
        R.image.generatePhrase.puzzle.image
    }
    
    static var person: Image {
        R.image.generatePhrase.person.image
    }
}
