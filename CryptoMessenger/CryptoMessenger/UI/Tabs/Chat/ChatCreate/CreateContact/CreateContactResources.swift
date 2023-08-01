import SwiftUI
import Foundation


protocol CreateContactResourcable{
    static var profileFromGallery: String { get }
    
    static var profileFromCamera: String { get }
    
    static var photoEditorTitle: String { get }
    
    static var createActionNewContact: String { get }
    
    static var profileDetailRightButton: String { get }
    
    static var facilityApproveNameSurname: String { get }
    
    static var createActionContactData: String { get }
    
    
    
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var textBoxBackground: Color { get }
    
}

enum CreateContactResources: CreateContactResourcable {
    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }
    
    static var profileFromCamera: String {
        R.string.localizable.profileFromCamera()
    }
    
    static var photoEditorTitle: String {
        R.string.localizable.photoEditorTitle()
    }
    
    static var createActionNewContact: String {
        R.string.localizable.createActionNewContact()
    }
    
    static var profileDetailRightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var facilityApproveNameSurname: String {
        R.string.localizable.facilityApproveNameSurname()
    }
    
    static var createActionContactData: String {
        R.string.localizable.createActionContactData()
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
}
