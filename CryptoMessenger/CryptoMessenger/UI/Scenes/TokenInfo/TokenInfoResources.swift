import SwiftUI

protocol TokenInfoResourcable {
    
    static var tokenInfoAddressCopied: String { get }
    static var tokenInfoTitle: String { get }
    static var tokenInfoShareAddress: String { get }
    
    
    static var copy: Image { get }
    static var xmarkCircle: Image { get }
    
    static var titleColor: Color { get }
    static var backgroundFodding: Color { get }
    static var background: Color { get }
    static var rectangleColor: Color { get }
    static var textColor: Color { get }
    static var logoBackground: Color { get }
    static var buttonBackground: Color { get }
}

enum TokenInfoResources: TokenInfoResourcable {
    static var tokenInfoAddressCopied: String {
        R.string.localizable.tokenInfoAddressCopied()
    }
    static var tokenInfoTitle: String {
        R.string.localizable.tokenInfoTitle()
    }
    static var tokenInfoShareAddress: String {
        R.string.localizable.tokenInfoShareAddress()
    }
    
    
    
    static var copy: Image {
        R.image.wallet.copy.image
    }
    static var xmarkCircle: Image {
        Image(uiImage: UIImage(systemName: "xmark.circle") ?? UIImage())
    }
    
    
    
    static var titleColor: Color {
            .chineseBlack
    }
    static var backgroundFodding: Color {
            .chineseBlack04
    }
    static var background: Color {
            .white
    }
    static var rectangleColor: Color{
        .gainsboro
    }
    static var textColor: Color{
        .romanSilver
    }
    static var logoBackground: Color{
        .dodgerTransBlue
    }
    static var buttonBackground: Color {
            .dodgerBlue
    }
}
