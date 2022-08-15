import Foundation

// MARK: - CountryCodes

enum CountryCodes: String {

    // MARK: - Properties

    case kLocationHongKong = "HK"
    case kLocationChina = "zh-CN"
}

// MARK: - LocationError

enum LocationError: Error {

    // MARK: - Types

    case LocationRequestNotPossible
}
