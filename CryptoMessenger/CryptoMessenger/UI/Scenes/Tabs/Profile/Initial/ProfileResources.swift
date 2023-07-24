import SwiftUI

protocol ProfileResourcable {
    static var profileFromGallery: String { get }
    static var profileFromCamera: String { get }
    static var photoEditorTitle: String { get }
    static var profileCopied: String { get }
    static var profileAddSocial: String { get }
    static var profileAdd: String { get }

    static var title: Color { get }
    static var backgroundFodding: Color { get }
    static var background: Color { get }
    static var buttonBackground: Color { get }
    static var avatarBackgorund: Color { get }
    
    static var emptyFeedImage: Image { get }
}

enum ProfileResources: ProfileResourcable {

    static var title: Color {
        .chineseBlack
    }

    static var backgroundFodding: Color {
        .chineseBlack04
    }

    static var background: Color {
        .white
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var avatarBackgorund: Color {
        .dodgerTransBlue
    }

    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }

    static var profileFromCamera: String {
        R.string.localizable.profileFromCamera()
    }

    static var photoEditorTitle: String {
        R.string.localizable.photoEditorTitle()
    }

    static var profileCopied: String {
        R.string.localizable.profileCopied()
    }

    static var profileAddSocial: String {
        R.string.localizable.profileAddSocial()
    }

    static var profileAdd: String {
        R.string.localizable.profileAdd()
    }
    
    static var emptyFeedImage: Image {
        R.image.media.noMedia.image
    }
}
