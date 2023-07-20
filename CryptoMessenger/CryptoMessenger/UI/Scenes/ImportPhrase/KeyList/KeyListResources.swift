import SwiftUI

// swiftlint: disable: all
// MARK: - ImportPhraseResourcable

protocol KeyListResourcable {
    static var walletManagerKeyManager: String { get }
    static var callListDelete: String { get }
    
    
    static var pencilImage: Image { get }
    static var trashBasketImage: Image { get }
    
    
    static var backgroundFodding: Color { get }
    static var background: Color { get }
    static var avatarBackground: Color { get }
    static var negativeColor: Color { get }
    static var buttonBackground: Color { get }
    
}

// MARK: - ImportPhraseResourcable(ImportPhraseResourcable)

enum KeyListResources: KeyListResourcable {
    static var walletManagerKeyManager: String {
        R.string.localizable.walletManagerKeyManager()
    }
    static var callListDelete: String {
        R.string.localizable.callListDelete()
    }
    
    
    static var pencilImage: Image {
        R.image.keyManager.pencil.image
    }
    static var trashBasketImage: Image {
        R.image.keyManager.trashBasket.image
    }
    
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    static var background: Color {
        .white 
    }
    static var avatarBackground: Color {
        .dodgerTransBlue
    }
    static var negativeColor: Color {
        .spanishCrimson
    }
    static var buttonBackground: Color {
        .dodgerBlue
    }
}
