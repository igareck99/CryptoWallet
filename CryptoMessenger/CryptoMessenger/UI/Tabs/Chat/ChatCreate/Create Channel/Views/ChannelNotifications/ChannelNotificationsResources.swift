import SwiftUI
import Foundation


protocol ChannelNotificationResourcable {
    static var channelNotificationsPopUpAlerts: String { get }
    
    static var channelNotificationsAlerts: String { get }
    
    
    
    static var checkmarkImage: Image { get }
    
    static var backButtonImage: Image { get }
    
    
    
    static var textColor: Color { get }
    
    static var background: Color { get }
}


enum ChannelNotificationResources: ChannelNotificationResourcable{
    static var channelNotificationsPopUpAlerts: String {
        R.string.localizable.channelNotificationsPopUpAlerts()
    }
    
    static var channelNotificationsAlerts: String {
        R.string.localizable.channelNotificationsAlerts()
    }
    
    
    
    static var checkmarkImage: Image {
        R.image.channelSettings.checkmark.image
    }
    
    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }
    
    
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var background: Color {
        .white
    }
}
