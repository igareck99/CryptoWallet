import MapKit

typealias Location = (lat: Double, long: Double)

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()

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

    @Published var userIsLocatable: Bool?
    @Published var activeGeofences = 0
    @Published var lastLocation: Location?

    private func updateAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            userIsLocatable = true
        case .denied:
            self.userIsLocatable = false
        default:
            userIsLocatable = nil
        }
    }

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

    enum LocationError: Error {
        case LocationRequestNotPossible
    }

    // Geofencing
    // Accuracy +/- 150m and often time delayed

    func getGeofences() -> [CLCircularRegion] {
        self.locationManager.monitoredRegions.compactMap { region in
            region as? CLCircularRegion
        }
    }

    private var didEnterGeofencedRegion: ((_ identifier: String) -> Void)?
    private var didLeaveGeofencedRegion: ((_ identifier: String) -> Void)?

    func setActionForEnteringGeofencedRegion(didEnterGeofencedRegion: @escaping (_ identifier: String) -> Void) {
        self.didEnterGeofencedRegion = didEnterGeofencedRegion
    }

    func setActionForLeavingGeofencedRegion(didLeaveGeofencedRegion: @escaping (_ identifier: String) -> Void) {
        self.didLeaveGeofencedRegion = didLeaveGeofencedRegion
    }

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

    func addGeofence(forRegion region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }

    func addGeofences(forRegions regions: [CLCircularRegion]) {
        regions.forEach { region in
            self.addGeofence(forRegion: region)
        }
    }

    func removeGeofence(forRegion region: CLCircularRegion) {
        self.locationManager.stopMonitoring(for: region)
    }

    func removeGeofence(forRegions regions: [CLCircularRegion]) {
        regions.forEach { region in
            self.removeGeofence(forRegion: region)
        }
    }

    func clearGeofences() {
        locationManager.monitoredRegions.forEach { region in
            self.locationManager.stopMonitoring(for: region)
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
