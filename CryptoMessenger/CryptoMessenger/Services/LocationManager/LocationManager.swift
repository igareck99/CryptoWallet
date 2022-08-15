import CoreLocation
import UIKit.UIApplication

// swiftlint: disable: all

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

    static let shared = LocationManagerUseCase()

    // MARK: - Private Properties

    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private var didEnterGeofencedRegion: ((_ identifier: String) -> Void)?
    private var didLeaveGeofencedRegion: ((_ identifier: String) -> Void)?
    @Injectable private(set) var locationService: LocationServiceProtocol

    // MARK: - Life Cycle

    init(requestLocation: Bool = true,
         locationService: LocationServiceProtocol = LocationService.shared) {
        super.init()
        configLocation(requestLocation, locationService)
        clearGeofences()
        activeGeofences = locationManager.monitoredRegions.count
        updateAuthorizationStatus()
        lastLocation = getUserLocation()
        // TODO: - Переделать
        if getUserLocation() != nil { } else {
            do {
                try locationService.requestLocationAccess()
            } catch {
                self.openAppSettings()
            }
        }
    }

    // MARK: - Internal Methods
    
    func configLocation(_ requestLocation: Bool, _ locationService: LocationServiceProtocol) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if requestLocation {
            try? locationService.requestLocationAccess()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorizationStatus()
    }

    func getGeofences() -> [CLCircularRegion] {
        locationManager.monitoredRegions.compactMap { region in
            region as? CLCircularRegion
        }
    }

    func setActionForEnteringGeofencedRegion(didEnterGeofencedRegion: @escaping (_ identifier: String) -> Void) {
        self.didEnterGeofencedRegion = didEnterGeofencedRegion
    }

    func setActionForLeavingGeofencedRegion(didLeaveGeofencedRegion: @escaping (_ identifier: String) -> Void) {
        self.didLeaveGeofencedRegion = didLeaveGeofencedRegion
    }

    func addGeofence(forRegion region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }

    func addGeofences(forRegions regions: [CLCircularRegion]) {
        regions.forEach { addGeofence(forRegion: $0) }
    }

    func removeGeofence(forRegion region: CLCircularRegion) {
        locationManager.stopMonitoring(for: region)
    }

    func removeGeofence(forRegions regions: [CLCircularRegion]) {
        regions.forEach { removeGeofence(forRegion: $0) }
    }

    func clearGeofences() {
        locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
    }

    // MARK: - Private Methods

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

// MARK: - LocationManager

extension LocationManagerUseCase: LocationServiceProtocol {

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

	func getCountryCode() -> String? {
		countryCode ?? nil
	}

	func getLastLocation() -> LocationData? {
		lastLocation
	}

	func getCountry() -> UserCountry {
		country
	}
    
    func requestLocationAccess() throws {
        try? locationService.requestLocationAccess()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManagerUseCase: CLLocationManagerDelegate {
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
