import SwiftUI

// swiftlint: disable: all
// MARK: - FriendProfileResourcable

protocol FriendProfileResourcable {
    
    static var profileCopied: String { get }
    
    static var settingsButton: Image { get }
    
    static var avatarThumbnail: Image { get }
    
    static var backgroundFodding: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var background: Color { get }
    
    static var titleColor: Color { get }
    
    static var avatarBackground: Color { get }
}

// MARK: - FriendProfileResources(FriendProfileResourcable)

enum FriendProfileResources: FriendProfileResourcable {
    
    static var profileCopied: String {
        R.string.localizable.profileCopied()
    }
    
    static var settingsButton: Image {
        R.image.navigation.settingsButton.image
    }
    
    static var avatarThumbnail: Image {
        R.image.profile.avatarThumbnail.image
    }
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var background: Color {
        .white 
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var avatarBackground: Color {
        .dodgerTransBlue
    }
}
