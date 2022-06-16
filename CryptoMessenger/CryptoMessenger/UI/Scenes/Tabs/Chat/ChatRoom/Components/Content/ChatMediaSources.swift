import SwiftUI


protocol ChatMediaSourcesable {

    // Images
    static var backButton: Image { get }

    static var settingsButton: Image { get }

    // Text
    static var friendProfileMedia: String { get }
}

enum ChatMediaSources: ChatMediaSourcesable {

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
}
