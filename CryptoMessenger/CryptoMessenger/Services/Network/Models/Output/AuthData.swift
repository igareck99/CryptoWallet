import Foundation

// MARK: - AuthData

struct AuthData: Codable {

    // MARK: - Internal Properties

    let device: DeviceData
    let phone: String
    let sms: String
}

// MARK: - DeviceData

struct DeviceData: Codable {

    // MARK: - Internal Properties

    let name: String
    let unique: String
}
