import Foundation

// swiftlint: disable: all

protocol LocationManagerUseCaseProtocol {
    func getCountry() -> UserCountry
    func getUserLocation() -> LocationData?
}

// MARK: - LocationManager

final class LocationManagerUseCase: NSObject, ObservableObject {

    var lastLocationPublisher: Published<LocationData?>.Publisher { $lastLocation }

    // MARK: - Internal Properties

    @Published var userIsLocatable: Bool?
    @Published var activeGeofences = 0
    @Published var lastLocation: LocationData?
    @Published var countryCode: String?
    @Published var country: UserCountry = .other
    @Published var service: GeoService = .apple

    // MARK: - Private Properties

    var locationService = LocationService()

    // MARK: - LifeCycle

    init(requestLocation: Bool = true) {
        super.init()
        locationService.clearGeofences()
        activeGeofences = locationService.locationManager.monitoredRegions.count
        updateAuthorizationStatus()
        lastLocation = locationService.getUserLocation()
        if locationService.getUserLocation() != nil { } else {
            do {
                try locationService.requestLocationAccess()
            } catch {
                self.locationService.openAppSettings()
            }
        }
    }

    // MARK: - Private Methods

    private func updateAuthorizationStatus() {
        switch locationService.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            userIsLocatable = true
        case .denied:
            userIsLocatable = false
        default:
            userIsLocatable = nil
        }
    }
}

// MARK: - LocationManagerUseCase(LocationManagerUseCaseProtocol)

extension LocationManagerUseCase: LocationManagerUseCaseProtocol {
    func getCountry() -> UserCountry {
        return locationService.getCountry()
    }
    
    func getUserLocation() -> LocationData? {
        return locationService.getUserLocation()
    }
}
