//swiftlint: disable all

import SwiftUI
import MapKit

// MARK: - MapViewModel

final class MapViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Injectable var locationManager: LocationServiceProtocol
    @State var region: MKCoordinateRegion
    
    let place: Place

    // MARK: - Lifecycle

    init(locationManager: LocationServiceProtocol = LocationManagerUseCase.shared,
         place: Place)
    {
        self.region = MKCoordinateRegion(
            center: .init(latitude: place.latitude, longitude: place.longitude),
            latitudinalMeters: 650,
            longitudinalMeters: 650
        )
        self.place = place
        self.locationManager = locationManager
    }

    func getCountry() -> UserCountry {
        return locationManager.getCountry()
    }
}
