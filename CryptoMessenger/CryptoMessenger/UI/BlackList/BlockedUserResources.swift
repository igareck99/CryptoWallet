import Foundation
import SwiftUI


protocol BlockedUserResourcable {
    static var background: Color { get }
    
    
    
    static var blockedUserAlertTitle: String { get }
    
    static var blockedUserApprove: String { get }
    
    static var blockedUserCancel: String { get }
    
    static var blackListTitle: String { get }
}


enum BlockedUserResources: BlockedUserResourcable {
    static var background: Color {
        .white 
    }
    
    
    
    static var blockedUserAlertTitle: String {
        R.string.localizable.blockedUserAlertTitle()
    }
    
    static var blockedUserApprove: String {
        R.string.localizable.blockedUserApprove()
    }
    
    static var blockedUserCancel: String {
        R.string.localizable.blockedUserCancel()
    }
    
    static var blackListTitle: String {
        R.string.localizable.blackListTitle()
    }
}
