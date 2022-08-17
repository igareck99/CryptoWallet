import Foundation

// MARK: - LocationServiceProtocol

protocol LocationServiceProtocol: AnyObject {
    func openAppSettings()
    func getUserLocation() -> LocationData?
    func getCountryCode() -> String?
    func getLastLocation() -> LocationData?
    func getCountry() -> UserCountry
    func requestLocationAccess() throws
}
