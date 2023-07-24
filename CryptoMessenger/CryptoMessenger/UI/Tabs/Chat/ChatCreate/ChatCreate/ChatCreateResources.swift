import SwiftUI
import Foundation

protocol ChatCreateResourcable {
    static var createActionSearch: String { get }
    
    static var createActionCancel: String { get }
    
    static var createActionInviteSection: String { get }
    
    static var chatContactEror: String { get }
    
    static var chatSettings: String { get }
    
    static var chatWelcome: String { get }
    
    static var createActionContactsSection: String { get }
    
    
    static var buttonBackground: Color { get }
    
    static var rectangleBackground: Color { get }
    
    static var titleColor: Color { get }
    
    static var background: Color { get }
    
    static var sectionBackground: Color { get }
    
    
    static var fatarrowImage: Image { get }
    
    static var fatloopImage: Image { get }
}


enum ChatCreateResources: ChatCreateResourcable {
    static var createActionSearch: String {
        R.string.localizable.createActionSearch()
    }
    
    static var createActionCancel: String {
        R.string.localizable.createActionCancel()
    }
    
    static var createActionInviteSection: String {
        R.string.localizable.createActionInviteSection()
    }
    
    static var chatContactEror: String {
        R.string.localizable.chatContactEror()
    }
    
    static var chatSettings: String {
        R.string.localizable.chatOpenSettings()
    }
    
    static var chatWelcome: String {
        R.string.localizable.chatWelcome()
    }
    
    static var createActionContactsSection: String {
        R.string.localizable.createActionContactsSection()
    }
    
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var rectangleBackground: Color {
        .romanSilver07
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var background: Color {
        .white 
    }
    
    
    static var fatarrowImage: Image {
        R.image.chat.fatarrow.image
    }
    
    static var fatloopImage: Image {
        R.image.chat.fatloop.image
    }
    
    static var sectionBackground: Color {
        .dodgerTransBlue
    }
}
