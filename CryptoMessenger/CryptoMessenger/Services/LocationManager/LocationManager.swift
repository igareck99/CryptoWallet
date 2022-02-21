import CoreLocation
import UIKit.UIApplication

// MARK: - Type

typealias Location = (lat: Double, long: Double)

// MARK: - LocationManager

final class LocationManager: NSObject, ObservableObject {

    // MARK: - LocationError

    enum LocationError: Error {

        // MARK: - Types

        case LocationRequestNotPossible
    }

    // MARK: - Internal Properties

    @Published var userIsLocatable: Bool?
    @Published var activeGeofences = 0
    @Published var lastLocation: Location?

    // MARK: - Private Properties

    private let locationManager = CLLocationManager()
    private var didEnterGeofencedRegion: ((_ identifier: String) -> Void)?
    private var didLeaveGeofencedRegion: ((_ identifier: String) -> Void)?

    // MARK: - Life Cycle

    init(requestLocation: Bool = false) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if requestLocation {
            try? requestLocationAccess()
        }
        clearGeofences()
        activeGeofences = locationManager.monitoredRegions.count
        updateAuthorizationStatus()
    }

    // MARK: - Internal Methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorizationStatus()
    }

    func getUserLocation() -> Location? {
        if let location = locationManager.location?.coordinate {
            lastLocation = (lat: location.latitude, long: location.longitude)
            return lastLocation
        }
        return nil
    }

    func requestLocationAccess() throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            throw LocationError.LocationRequestNotPossible
        }
    }

    func openAppSettings() {
        if let settingsULR = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsULR, options: [:], completionHandler: nil)
        }
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

// MARK: - LocationManager (CLLocationManagerDelegate)

extension LocationManager: CLLocationManagerDelegate {
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
        lastLocation = (lat: location.coordinate.latitude, long: location.coordinate.longitude)
    }
}
