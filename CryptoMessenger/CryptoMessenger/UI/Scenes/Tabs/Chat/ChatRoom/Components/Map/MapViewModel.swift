import SwiftUI

// MARK: - MapViewModel

final class MapViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Injectable var locationManager: LocationManager

    // MARK: - Lifecycle

    init(locationManager: LocationManager = LocationManagerUseCase.shared) {
        self.locationManager = locationManager
    }

    func getCountry() -> UserCountry {
        return locationManager.getCountry()
    }
}
