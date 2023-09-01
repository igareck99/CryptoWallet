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

    static let Moscow = Place(name: "Moscow", latitude: 37.628797, longitude: 55.741850)

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
}
