import SwiftUI

// MARK: - ProfileDetailSourcable

protocol ProfileDetailSourcable {

    static var backImage: Image { get }

    static var whiteCamera: Image { get }

    static var approveBlue: Image { get }

    static var web: Image { get }

    static var leave: Image { get }

    static var profileDetailRightButton: String { get }

    static var tabProfile: String { get }

    static var profileDetailLogoutAlertApprove: String { get }

    static var profileDetailFirstItemCell: String { get }

    static var profileAboutUser: String { get }

    static var profileDetailLogoutAlertCancel: String { get }

    static var profileDetailLogoutAlertMessage: String { get }

    static var profileDetailLogoutAlertTitle: String { get }

    static var profileFromGallery: String { get }

    static var profileFromCamera: String { get }
}

class ProfileDetailResources: ProfileDetailSourcable {
 
    static var backImage: Image {
        R.image.navigation.backButton.image
    }
    
    static var whiteCamera: Image {
        R.image.profileDetail.whiteCamera.image
    }
    
    static var approveBlue: Image {
        R.image.profileDetail.approveBlue.image
    }
    
    static var leave: Image {
        R.image.profileDetail.leave.image
    }
    
    static var web: Image {
        R.image.profileDetail.web.image
    }
    
    static var profileDetailRightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var tabProfile: String {
        R.string.localizable.tabProfile()
    }
    
    static var profileDetailLogoutAlertApprove: String { 
        R.string.localizable.profileDetailLogoutAlertApprove()
    }
    
    static var profileDetailFirstItemCell: String {
        R.string.localizable.profileDetailFirstItemCell()
    }
    
    static var profileAboutUser: String { 
        R.string.localizable.profileAboutUser()
    }
    
    static var profileDetailLogoutAlertCancel: String {
        R.string.localizable.profileDetailLogoutAlertCancel()
    }
    
    static var profileDetailLogoutAlertMessage: String { 
        R.string.localizable.profileDetailLogoutAlertMessage()
    }
    
    static var profileDetailLogoutAlertTitle: String { 
        R.string.localizable.profileDetailLogoutAlertTitle()
    }
    
    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }

    static var profileFromCamera: String { 
        R.string.localizable.profileFromCamera()
    }
}
