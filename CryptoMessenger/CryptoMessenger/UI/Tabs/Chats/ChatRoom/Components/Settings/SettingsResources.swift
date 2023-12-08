import SwiftUI
import Foundation


protocol SettingsResourcable {
    static var settings: String { get }
    
    static var profileDetailRightButton: String { get }
    
    static var profileDetailLogoutAlertTitle: String { get }
    
    static var profileDetailLogoutAlertApprove: String { get }
    
    static var createChannelTitle: String { get }
    
    static var contactChatDetailInfo: String { get }
    
    static var createChannelDescription: String { get }
    
    static var channelInfoParticipant: String { get }
    
    static var channelInfoOpen: String { get }
    
    
    
    static var titleColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var dividerColor: Color { get }
    
    static var background: Color { get }
    
    static var backgroundFodding: Color { get }
    
    static var negativeTintColor: Color { get }
}

enum SettingsResources: SettingsResourcable {
    static var settings: String {
        R.string.localizable.chatSettings()
    }
    
    static var profileDetailRightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var profileDetailLogoutAlertTitle: String {
        R.string.localizable.profileDetailLogoutAlertTitle()
    }
    
    static var profileDetailLogoutAlertApprove: String {
        R.string.localizable.profileDetailLogoutAlertApprove()
    }
    
    static var createChannelTitle: String {
        R.string.localizable.createChannelTitle()
    }
    
    static var contactChatDetailInfo: String {
        R.string.localizable.contactChatDetailInfo()
    }
    
    static var createChannelDescription: String {
        R.string.localizable.createChannelDescription()
    }
    
    static var channelInfoParticipant: String {
        R.string.localizable.channelInfoParticipant()
    }
    
    static var channelInfoOpen: String {
        R.string.localizable.channelInfoOpen()
    }
    
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var dividerColor: Color {
        .ashGray
    }
    
    static var background: Color {
        .white 
    }
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var negativeTintColor: Color {
        .spanishCrimson01
    }
}
