import Foundation
import SwiftUI

protocol ChatGroupResourcable {
    static var profileFromGallery: String { get }

    static var profileFromCamera: String { get }

    static var photoEditorTitle: String { get }
    
    static var chatMenuViewGroupName: String { get }
    
    static var profileDetailRightButton: String { get }
    
    static var createChannelTitle: String { get }
    
    static var contactChatDetailInfo: String { get }
    
    static var createChannelDescription: String { get }

    static var titleColor: Color { get }

    static var textColor: Color { get }

    static var buttonBackground: Color { get }

    static var textBoxBackground: Color { get }

    static var background: Color { get }
}

enum ChatGroupResources: ChatGroupResourcable {
    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }

    static var profileFromCamera: String {
        R.string.localizable.profileFromCamera()
    }

    static var photoEditorTitle: String {
        R.string.localizable.photoEditorTitle()
    }
    
    static var chatMenuViewGroupName: String {
        R.string.localizable.chatMenuViewGroupName()
    }
    
    static var createChannelTitle: String {
        R.string.localizable.createChannelTitle()
    }
    
    static var profileDetailRightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var contactChatDetailInfo: String {
        R.string.localizable.contactChatDetailInfo()
    }
    
    static var createChannelDescription: String {
        R.string.localizable.createChannelDescription()
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var textColor: Color {
        .romanSilver
    }

    static var buttonBackground: Color {
        .dodgerBlue
    }

    static var textBoxBackground: Color {
        .aliceBlue
    }

    static var background: Color {
        .white
    }
}
