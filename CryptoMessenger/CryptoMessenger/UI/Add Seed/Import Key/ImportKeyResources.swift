import Foundation
import SwiftUI

protocol ImportKeyResourcable {
    static var phraseManagerKeyImportSucces: String { get }
    static var snackbarBackground: Color { get }
    static var generatePhraseSaved: String { get }
    static var keyImportTitle: String { get }
    static var textBoxBackground: Color { get }
    static var titleColor: Color { get }
    static var importEnterPrivateKey: String { get }
    static var textColor: Color { get }
    static var negativeColor: Color { get }
    static var generatePhraseErrorKey: String { get }
    static var importHowImportKey: String { get }
    static var buttonBackground: Color { get }
    static var importImport: String { get }
    static var background: Color { get }
    static var innactiveButtonBackground: Color { get }
    static var importTitle: String { get }
    static var backButtonImage: Image { get }
}

// MARK: - ImportKeyResourcable

enum ImportKeyResources: ImportKeyResourcable {
    static var phraseManagerKeyImportSucces: String {
        R.string.localizable.phraseManagerKeyImportSucces()
    }

    static var snackbarBackground: Color {
        .greenCrayola
    }

    static var generatePhraseSaved: String {
        R.string.localizable.generatePhraseSaved()
    }

    static var keyImportTitle: String {
        R.string.localizable.keyImportTitle()
    }

    static var textBoxBackground: Color {
        .aliceBlue
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var importEnterPrivateKey: String {
        R.string.localizable.importEnterPrivateKey()
    }

    static var textColor: Color {
        .romanSilver
    }

    static var negativeColor: Color {
        .spanishCrimson
    }

    static var generatePhraseErrorKey: String {
        R.string.localizable.generatePhraseErrorKey()
    }

    static var importHowImportKey: String {
        R.string.localizable.importHowImportKey()
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var importImport: String {
        R.string.localizable.importImport()
    }

    static var background: Color {
        .white
    }

    static var innactiveButtonBackground: Color {
        .ghostWhite
    }

    static var importTitle: String {
        R.string.localizable.importTitle()
    }

    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }
}
