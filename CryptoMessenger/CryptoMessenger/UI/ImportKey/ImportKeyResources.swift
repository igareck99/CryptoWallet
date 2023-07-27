import Foundation
import SwiftUI


protocol ImportKeyResourcable {
    
    static var importTitle: String { get }
    
    static var keyImportTitle: String { get }
    
    static var importEnterPrivateKey: String { get }
    
    static var generatePhraseErrorKey: String { get }
    
    static var importHowImportKey: String { get }
    
    static var importChooseWalletType: String { get }
    
    static var importImport: String { get }
    
    static var phraseManagerKeyImportSucces: String { get }
    
    static var generatePhraseSaved: String { get }
    
    
    
    static var snackbarBackground: Color { get }
    
    static var backgroundFodding: Color { get }
    
    static var background: Color { get }
    
    static var titleColor: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var negativeColor: Color { get }
    
    static var avatarBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var innactiveButtonBackground: Color { get }
    
    
    
    static var walletImage: Image { get }
    
    static var downSideArrowImage: Image { get }
}


enum ImportKeyResources: ImportKeyResourcable {
    
    static var importTitle: String {
        R.string.localizable.importTitle()
    }
    
    static var keyImportTitle: String {
        R.string.localizable.keyImportTitle()
    }
    
    static var importEnterPrivateKey: String {
        R.string.localizable.importEnterPrivateKey()
    }
    
    static var generatePhraseErrorKey: String {
        R.string.localizable.generatePhraseErrorKey()
    }
    
    static var importHowImportKey: String {
        R.string.localizable.importHowImportKey()
    }
    
    static var importChooseWalletType: String {
        R.string.localizable.importChooseWalletType()
    }
    
    static var importImport: String {
        R.string.localizable.importImport()
    }
    
    static var phraseManagerKeyImportSucces: String {
        R.string.localizable.phraseManagerKeyImportSucces()
    }
    
    static var generatePhraseSaved: String {
        R.string.localizable.generatePhraseSaved()
    }
    
    
    
    static var snackbarBackground: Color {
        .greenCrayola
    }
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var background: Color {
        .white 
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var negativeColor: Color {
        .spanishCrimson
    }
    
    static var avatarBackground: Color {
        .dodgerTransBlue
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var innactiveButtonBackground: Color {
        .ghostWhite
    }
    
    
    
    static var walletImage: Image {
        R.image.wallet.wallet.image
    }
    
    static var downSideArrowImage: Image {
        R.image.answers.downsideArrow.image
    }
}
