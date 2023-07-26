import SwiftUI

// MARK: - PinCodeSourcesable

protocol PinCodeSourcesable {
    static var enterPassword: String { get }
    
    static var repeatPassword: String { get }
    
    static var deletePasswordTitle: String { get }
    
    static var deletePasswordDescription: String { get }
    
    static var auraLogoRed: Image { get }
    
    static var auraLogo: Image { get }
    
    static var passwordHasBeenSet: String { get }
    
    static var cancel: String { get }
    
    static var delete: String { get }
}

// MARK: - PinCodeSources(PinCodeSourcesable)

enum PinCodeSources: PinCodeSourcesable {

    static var auraLogoRed: Image {
        R.image.pinCode.avatarRed.image
    }
    
    static var auraLogo: Image {
        R.image.pinCode.aura.image
    }
    
    static var repeatPassword: String {
        R.string.localizable.pinCodeRepeatPassword()
    }
    
    static var deletePasswordTitle: String {
        R.string.localizable.pinCodeRemovePassword()
    }
    
    static var deletePasswordDescription: String {
        R.string.localizable.pinCodeAnwserRemovePassword()
    }
    
    static var enterPassword: String {
        R.string.localizable.pinCodeEnterPassword()
    }

    static var passwordHasBeenSet: String {
        R.string.localizable.pinCodeSuccessPassword()
    }
    
    static var cancel: String {
        R.string.localizable.personalizationCancel()
    }
    
    static var delete: String {
        R.string.localizable.profileDetailDeleteAlertApprove()
    }
}
