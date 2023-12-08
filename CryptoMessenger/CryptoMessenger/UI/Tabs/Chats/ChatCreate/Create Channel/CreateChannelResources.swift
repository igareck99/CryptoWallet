import Foundation
import SwiftUI

protocol CreateChannelResourcable {
    static var backButtonImage: Image { get }
    
    
    static var profileFromGallery: String { get }
    
    static var profileFromCamera: String { get }
    
    static var photoEditorTitle: String { get }
    
    static var profileDetailRightButton: String { get }
    
    static var createChannelDescription: String { get }
    
    static var createActionCreateChannel: String { get }
    
    static var createChannelChannelType: String { get }
    
    
    static var buttonBackground: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var dividerColor: Color { get }
    
    static var textColor: Color { get }
    
    static var titleColor: Color { get }
}

enum CrateChannelResources : CreateChannelResourcable {
    static var backButtonImage: Image {
        R.image.navigation.backButton.image
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
    
    static var profileDetailRightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var createChannelDescription: String {
        R.string.localizable.createChannelDescription()
    }
    
    static var createActionCreateChannel: String {
        R.string.localizable.createActionCreateChannel()
    }
    
    static var createChannelChannelType: String {
        R.string.localizable.createChannelChannelType()
    }
    
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var textBoxBackground: Color {
        .aliceBlue  
    }
    
    static var dividerColor: Color {
        .gainsboro
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
}
