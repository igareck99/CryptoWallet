import SwiftUI

// swiftlint: disable: all
// MARK: - SuccessFacilityResourcable

protocol SuccessFacilityResourcable {
    
    static var close: Image { get }
    
    static var greenCheck: Image { get }
    
    static var address: Image { get }
    
    static var successFacilityViewTitle: String { get }
    
    static var successFacilityViewAddFavorites: String { get }
    
    static var successFacilityViewOKClose: String { get }
    
    static var successFacilityViewShowTransaction: String { get }
    
    static var background: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var avatarBackground: Color { get }
}

// MARK: - SuccessFacilityResources(SuccessFacilityResourcable)

enum SuccessFacilityResources: SuccessFacilityResourcable {

    static var close: Image {
        R.image.buyCellsMenu.close.image
    }
    
    static var greenCheck: Image {
        R.image.transaction.greenCheck.image
    }
    
    static var address: Image {
        R.image.facilityApprove.address.image
    }
    
    static var successFacilityViewTitle: String {
        R.string.localizable.successFacilityViewTitle()
    }
    
    static var successFacilityViewAddFavorites: String {
        R.string.localizable.successFacilityViewAddFavorites()
    }
    
    static var successFacilityViewOKClose: String {
        R.string.localizable.successFacilityViewOKClose()
    }
    
    static var successFacilityViewShowTransaction: String {
        R.string.localizable.successFacilityViewShowTransaction()
    }
    
    static var background: Color {
        .white
    }
    
    static var avatarBackground: Color {
        .dodgerTransBlue
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var textColor: Color {
        .romanSilver
    }
}
