import SwiftUI

protocol WarningViewResourcable {
    static var generatePhraseWarning: String { get }
    static var generatePhraseWarningDescription: String { get }
    static var person: Image { get }
    static var generatePhraseImportKey: String { get }
    static var buttonBackground: Color { get }
    static var keyGenerationCreateButton: String { get }
    static var background: Color { get }
    static var backButtonImage: Image { get }
    static var titleColor: Color { get }
    static var textColor: Color { get }
}

// MARK: - WarningViewResourcable

enum WarningViewResources: WarningViewResourcable {

    static var generatePhraseWarning: String {
        R.string.localizable.generatePhraseWarning()
    }

    static var generatePhraseWarningDescription: String {
        R.string.localizable.generatePhraseWarningDescription()
    }

    static var person: Image {
        R.image.generatePhrase.person.image
    }

    static var generatePhraseImportKey: String {
        R.string.localizable.generatePhraseImportKey()
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var keyGenerationCreateButton: String {
        R.string.localizable.keyGenerationCreateButton()
    }

    static var background: Color {
        .white
    }

    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var textColor: Color {
        .romanSilver
    }
}
