import SwiftUI
import Foundation


protocol MembersResourcable {
    static var channelInfoChatParticipant: String { get }
    
    
    
    static var titleColor: Color { get }
    
    static var dividerColor: Color { get }
    
    static var background: Color { get }
}

enum MembersResources: MembersResourcable {
    static var channelInfoChatParticipant: String {
        R.string.localizable.channelInfoChatParticipants()
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
