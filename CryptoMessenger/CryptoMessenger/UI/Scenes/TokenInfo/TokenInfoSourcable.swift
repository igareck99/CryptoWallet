import SwiftUI

// swiftlint: disable: all
// MARK: - TokenInfoResourcable

protocol TokenInfoResourcable {
    
    static var tokenInfoAddressCopied: String { get }
    
    static var tokenInfoTitle: String { get }
    
    static var tokenInfoShareAddress: String { get }
    
    static var copy: Image { get }
    
    static var xmarkCircle: Image { get }
}

// MARK: - TokenInfoResources(TokenInfoResourcable)

enum TokenInfoResources: TokenInfoResourcable {

    static var tokenInfoAddressCopied: String {
        R.string.localizable.tokenInfoAddressCopied()
    }
    
    static var tokenInfoTitle: String {
        R.string.localizable.tokenInfoTitle()
    }
    
    static var copy: Image {
        R.image.wallet.copy.image
    }
    
    static var xmarkCircle: Image {
        Image(uiImage: UIImage(systemName: "xmark.circle") ?? UIImage())
    }
    
    static var tokenInfoShareAddress: String {
        R.string.localizable.tokenInfoShareAddress()
    }
}
