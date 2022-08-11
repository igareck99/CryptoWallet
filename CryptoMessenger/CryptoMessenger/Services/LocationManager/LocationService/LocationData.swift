import Foundation

// MARK: - LocationData

struct LocationData {
    let lat: Double
    let long: Double
}

// MARK: - UserCountry

enum UserCountry {
    case china
    case other
}

// MARK: - GeoService

enum GeoService: CaseIterable {
    case baidu
    case apple
    case google
    case yandex
    case doubleGis
}

// MARK: - GeoService

struct Place: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
}
