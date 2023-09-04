import SwiftUI
import Foundation


protocol SecurityResourcable {
    static var securityTitle: String { get }
    
    static var securityPrivacy: String { get }
    
    static var securityPinCodeTitle: String { get }
    
    static var securityBiometryEnterTitle: String { get }
    
    static var securityBiometryEnterState: String { get }
    
    static var securityFalsePasswordTitle: String { get }
    
    static var securityFalsePasswordState: String { get }
    
    static var securityBiometryEror: String { get }
    
    
    
    static var innactiveBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var background: Color { get }
}


enum SecurityResources: SecurityResourcable {
    static var securityTitle: String {
        R.string.localizable.securityTitle()
    }
    
    static var securityPrivacy: String {
        R.string.localizable.securityPrivacy()
    }
    
    static var securityPinCodeTitle: String {
        R.string.localizable.securityPinCodeTitle()
    }
    
    static var securityBiometryEnterTitle: String {
        R.string.localizable.securityBiometryEnterTitle()
    }
    
    static var securityBiometryEnterState: String {
        R.string.localizable.securityBiometryEnterState()
    }
    
    static var securityFalsePasswordTitle: String {
        R.string.localizable.securityFalsePasswordTitle()
    }
    
    static var securityFalsePasswordState: String {
        R.string.localizable.securityFalsePasswordState()
    }
    
    static var securityBiometryEror: String {
        R.string.localizable.securityBiometryEror()
    }
    
    
    static var innactiveBackground: Color {
        .ghostWhite
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var background: Color {
        .white 
    }
}
