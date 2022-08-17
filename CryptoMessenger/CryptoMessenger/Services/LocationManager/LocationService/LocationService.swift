import CoreLocation

// swiftlint: disable: all

// MARK: - LocationService

final class LocationService: NSObject, ObservableObject, LocationServiceProtocol {

    // MARK: - Internal Properties

    var lastLocationPublisher: Published<LocationData?>.Publisher { $lastLocation }
    @Published var lastLocation: LocationData?
    @Published var countryCode: String?
    @Published var country: UserCountry = .other
    @Published var service: GeoService = .apple
    @Published var activeGeofences = 0
    @Published var userIsLocatable: Bool?

    // MARK: - Private Properties

    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    private var didEnterGeofencedRegion: ((_ identifier: String) -> Void)?
    private var didLeaveGeofencedRegion: ((_ identifier: String) -> Void)?
    static let shared = LocationService()
    
    // MARK: - LifeCycle

    init(requestLocation: Bool = true) {
        super.init()
        configLocationService(requestLocation)
        clearGeofences()
        activeGeofences = locationManager.monitoredRegions.count
        updateAuthorizationStatus()
        lastLocation = getUserLocation()
        checkUserLocation()
    }

    // MARK: - Internal Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorizationStatus()
    }

    func openAppSettings() {
        if let settingsULR = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsULR, options: [:], completionHandler: nil)
        }
    }

    func getUserLocation() -> LocationData? {
        locationManager.startUpdatingLocation()
        if let location = locationManager.location?.coordinate {
            lastLocation = LocationData(lat: location.latitude, long: location.longitude)
            if countryCode == CountryCodes.kLocationChina.rawValue || countryCode == CountryCodes.kLocationHongKong.rawValue {
                country = .china
            } else { country = .other }
            locationManager.stopUpdatingLocation()
            return lastLocation
        }
        return nil
    }

    func getLastLocation() -> LocationData? {
        lastLocation
    }

    func getCountryCode() -> String? {
        return countryCode
    }

    func getCountry() -> UserCountry {
        return country
    }
    
    func clearGeofences() {
        locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
    }
    
    func requestLocationAccess() throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            debugPrint("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("authorizedAlways")
            locationManager.startUpdatingLocation()
        case .denied:
            debugPrint("denied")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        default:
            debugPrint("LocationError.LocationRequestNotPossible")
            throw LocationError.LocationRequestNotPossible
        }
    }
    
    // MARK: - Private Methods
    
    private func configLocationService(_ requestLocation: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if requestLocation {
            try? requestLocationAccess()
        }
    }
    
    private func checkUserLocation() {
        if getUserLocation() != nil { } else {
            do {
                try requestLocationAccess()
            } catch {
                self.openAppSettings()
            }
        }
    }

    private func updateAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            userIsLocatable = true
        case .denied:
            userIsLocatable = false
        default:
            userIsLocatable = nil
        }
    }
}

// MARK: - LocationService (CLLocationManagerDelegate)

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let onEnterRegion = didEnterGeofencedRegion {
            onEnterRegion(region.identifier)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let onLeaveRegion = didLeaveGeofencedRegion {
            onLeaveRegion(region.identifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        activeGeofences = manager.monitoredRegions.count
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = LocationData(lat: location.coordinate.latitude,
                                long: location.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            debugPrint("Country: ", placemark.isoCountryCode ?? "")
            self.countryCode = placemark.isoCountryCode ?? ""
            if self.countryCode == CountryCodes.kLocationChina.rawValue || self.countryCode == CountryCodes.kLocationHongKong.rawValue {
                self.country = .china
                
                // TODO: Не заводится пока если не в AppDelegate
//                self.baiduStart()
            } else { self.country = .other }
        }
    }
}

