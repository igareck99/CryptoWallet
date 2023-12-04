import SwiftUI

protocol WatchKeyResourcable {
    static var phraseManagerYourSecretPhrase: String { get }
    static var generatePhraseGeneratedDescription: String { get }
    static var textColor: Color { get }
    static var generatePhraseCopied: String { get }
    static var snackbarBackground: Color { get }
    static var titleColor: Color { get }
    static var textBoxBackground: Color { get }
    static var generatePhraseCopyPhrase: String { get }
    static var background: Color { get }
    static var buttonBackground: Color { get }
    static var backButtonImage: Image { get }
}

enum WatchKeyResources: WatchKeyResourcable {

    static var phraseManagerYourSecretPhrase: String {
        R.string.localizable.phraseManagerYourSecretPhrase()
    }

    static var generatePhraseGeneratedDescription: String {
        R.string.localizable.generatePhraseGeneratedDescription()
    }

    static var textColor: Color {
        .romanSilver
    }

    static var generatePhraseCopied: String {
        R.string.localizable.generatePhraseCopied()
    }

    static var snackbarBackground: Color {
        .greenCrayola
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var textBoxBackground: Color {
        .clear
    }

    static var generatePhraseCopyPhrase: String {
        R.string.localizable.generatePhraseCopyPhrase()
    }

    static var background: Color {
        .white
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }
}
