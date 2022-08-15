import Foundation

// MARK: - Country Service Parameters

enum UserCountry {
    case china
    case other
}

enum GeoService {
    case baidu
    case apple
    case google
}

struct Place: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
}
