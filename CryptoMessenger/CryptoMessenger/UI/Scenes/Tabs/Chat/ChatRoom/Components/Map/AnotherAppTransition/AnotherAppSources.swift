import SwiftUI

// MARK: - AnotherAppSourcesable

protocol AnotherAppSourcesable {
    
    // Image
    
    static var appleMapsImage: UIImage { get }

    static var googleMapsImage: UIImage { get }
    
    static var yandexMapsImage: UIImage { get }
    
    static var doubleGisImage: UIImage { get }

    // Text
    static var cancel: String { get }

    static var openWith: String { get }

    static var shareWith: String { get }
    
    static var appleMaps: String { get }
    
    static var googleMaps: String { get }
    
    static var yandexMaps: String { get }
    
    static var doubleGis: String { get }
}

// MARK: - AnotherAppResources(AnotherAppSourcesable)

enum AnotherAppResources: AnotherAppSourcesable {

    // Image

    static var appleMapsImage: UIImage {
        R.image.chat.mapsLogo.appleMaps() ?? UIImage()
    }

    static var googleMapsImage: UIImage {
        R.image.chat.mapsLogo.googleMaps() ?? UIImage()
    }

    static var yandexMapsImage: UIImage {
        R.image.chat.mapsLogo.yandexMaps() ?? UIImage()
    }

    static var doubleGisImage: UIImage {
        R.image.chat.mapsLogo.gisMaps() ?? UIImage()
    }

    // Text

    static var cancel: String {
        R.string.localizable.personalizationCancel()
    }

    static var openWith: String {
        R.string.localizable.locationPickerViewOpenWith()
    }

    static var shareWith: String {
        R.string.localizable.locationPickerViewShare()
    }
    
    static var yandexMaps: String {
        "Yandex Maps"
    }
    
    static var doubleGis: String {
        "2Gis"
    }
    
    static var googleMaps: String {
        "Google Maps"
    }
    
    static var appleMaps: String {
        "Apple Maps"
    }
}
