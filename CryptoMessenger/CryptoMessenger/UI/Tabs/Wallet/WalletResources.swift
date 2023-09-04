import Foundation
import SwiftUI


protocol WalletResourcable {
    
    static var tabWallet: String { get }
    
    static var walletNoData: String { get }
    
    static var walletAddWalletLong: String { get }
    
    static var walletAddWalletShort: String { get }
    
    static var tabOverallBalance: String { get }
    
    static var walletTransaction: String { get }
    
    static var walletSend: String { get }
    
    static var walletManagerMakeYourFirstTransaction: String { get }
    
    
    
    
    static var backgroundFodding: Color { get }
    
    static var background: Color { get }
    
    static var titleColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var avatarBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var innactiveButtonBackground: Color { get }
}


enum WalletResources: WalletResourcable {
    static var tabWallet: String {
        R.string.localizable.tabWallet()
    }
    
    static var walletNoData: String {
        R.string.localizable.walletNoData()
    }
    
    static var walletAddWalletLong: String {
        R.string.localizable.walletAddWalletLong()
    }
    
    static var walletAddWalletShort: String {
        R.string.localizable.walletAddWalletShort()
    }
    
    static var tabOverallBalance: String {
        R.string.localizable.tabOverallBalance()
    }
    
    static var walletTransaction: String {
        R.string.localizable.walletTransaction()
    }
    
    static var walletSend: String {
        R.string.localizable.walletSend()
    }
    
    static var walletManagerMakeYourFirstTransaction: String {
        R.string.localizable.walletManagerMakeYourFirstTransaction()
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
    
    static var buttonBackground: Color {
        .dodgerBlue
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
}
