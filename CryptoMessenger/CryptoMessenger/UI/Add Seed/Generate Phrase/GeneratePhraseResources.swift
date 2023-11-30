import SwiftUI

protocol GeneratePhraseResourcable {
    static var generatePhraseCopied: String { get }
    static var snackbarBackground: Color { get }
    static var generatePhraseSecretPhraseTitle: String { get }
    static var secretPhraseDescription: String { get }
    static var generatePhraseQuestion: String { get }
    static var generatePhraseSecretDescription: String { get }
    static var textColor: Color { get }
    static var puzzle: Image { get }
    static var buttonBackground: Color { get }
    static var generatePhraseImportKey: String { get }
    static var keyGenerationCreateButton: String { get }
    static var background: Color { get }
    static var textBoxBackground: Color { get }
    static var titleColor: Color { get }
    static var backButtonImage: Image { get }
}

// MARK: - GeneratePhraseResourcable

enum GeneratePhraseResources: GeneratePhraseResourcable {
    static var generatePhraseCopied: String {
        R.string.localizable.generatePhraseCopied()
    }

    static var snackbarBackground: Color {
        .greenCrayola
    }

    static var generatePhraseSecretPhraseTitle: String {
        R.string.localizable.generatePhraseSecretPhraseTitle()
    }

    static var secretPhraseDescription: String {
        generatePhraseSecretDescription + "\n\n" + generatePhraseQuestion
    }

    static var generatePhraseSecretDescription: String {
        R.string.localizable.generatePhraseSecretDescription()
    }

    static var generatePhraseQuestion: String {
        R.string.localizable.generatePhraseQuestion()
    }

    static var textColor: Color {
        .romanSilver
    }

    static var puzzle: Image {
        R.image.generatePhrase.puzzle.image
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var generatePhraseImportKey: String {
        R.string.localizable.generatePhraseImportKey()
    }

    static var keyGenerationCreateButton: String {
        R.string.localizable.keyGenerationCreateButton()
    }

    static var background: Color {
        .white
    }

    static var textBoxBackground: Color {
        .aliceBlue
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }
}
