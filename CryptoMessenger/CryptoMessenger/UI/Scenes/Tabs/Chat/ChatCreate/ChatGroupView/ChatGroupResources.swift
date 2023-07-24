import SwiftUI
import Foundation


protocol ChatGroupResourcable {
    static var profileFromGallery: String { get }
    
    static var profileFromCamera: String { get }
    
    static var photoEditorTitle: String { get }
    
    
    
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var background: Color { get }
}


enum ChatGroupResources: ChatGroupResourcable{
    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }
    
    static var profileFromCamera: String {
        R.string.localizable.profileFromCamera()
    }
    
    static var photoEditorTitle: String {
        R.string.localizable.photoEditorTitle()
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
