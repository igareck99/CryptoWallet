import SwiftUI

// MARK: - ChannelMediaSourcesable

protocol ChannelMediaSourcesable {

    // Images
    static var backButton: Image { get }

    static var settingsButton: Image { get }

    // Text
    static var friendProfileMedia: String { get }
    
    static var channelInfoChannelMedia: String { get }
    
    
    static var titleColor: Color { get }
    
    static var backgroundFodding: Color { get }
    
    static var textBoxBackground: Color { get }
}

// MARK: - ChannelMediaSources(ChannelMediaSourcesable)

enum ChannelMediaSources: ChannelMediaSourcesable {

    // Images
    static var backButton: Image {
        R.image.navigation.backButton.image
    }

    static var settingsButton: Image {
        R.image.wallet.settings.image
    }

    // Text
    static var friendProfileMedia: String {
        R.string.localizable.friendProfileMedia()
    }
    
    static var channelInfoChannelMedia: String {
        R.string.localizable.channelInfoChannelMedia()
    }
    
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
}
