import SwiftUI

protocol AuraMapSourcesable {
    
    // Images
    static var marker: Image { get }
    
    // Text
    static var locationPickerViewLocation: String { get }
    
    static var locationPickerViewSearchPlaceholder: String { get }
    
    static var createActionCancel: String { get }
    
    static var markerString: String { get }
}

// MARK: - AuraMapSourcesable

enum AuraMapSources: AuraMapSourcesable {
    
    // Images
    
    static var marker: Image {
        R.image.chat.location.marker.image
    }
    
    // Text
    
    static var locationPickerViewLocation: String {
        R.string.localizable.locationPickerViewLocation()
    }
    
    static var locationPickerViewSearchPlaceholder: String {
        R.string.localizable.locationPickerViewSearchPlaceholder()
    }
    
    static var createActionCancel: String {
        R.string.localizable.createActionCancel()
    }
    
    static var markerString: String {
        "Chat/Location/marker"
    }
}
