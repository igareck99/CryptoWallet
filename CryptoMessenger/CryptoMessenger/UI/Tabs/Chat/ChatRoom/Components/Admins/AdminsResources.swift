import SwiftUI
import Foundation


protocol AdminsResourcable {
    static var channelInfoAdmins: String { get }
    
    
    
    static var titleColor: Color { get }
    
    static var dividerColor: Color { get }
    
    static var background: Color { get }
}

enum AdminsResources: AdminsResourcable {
    static var channelInfoAdmins: String {
        R.string.localizable.channelInfoAdmins()
    }
    
    
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var dividerColor: Color {
        .ashGray
    }
    
    static var background: Color {
        .white 
    }
}
