import SwiftUI

// MARK: - AnotherAppData

struct AnotherAppData: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let image: UIImage
    let name: String
    let mapsApp: GeoService
}
