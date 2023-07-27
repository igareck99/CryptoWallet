import SwiftUI

// swiftlint: disable: all
// MARK: - FriendProfileResourcable

protocol FriendProfileResourcable {
    
    static var profileCopied: String { get }
    
    static var settingsButton: Image { get }
    
    static var avatarThumbnail: Image { get }
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
}
