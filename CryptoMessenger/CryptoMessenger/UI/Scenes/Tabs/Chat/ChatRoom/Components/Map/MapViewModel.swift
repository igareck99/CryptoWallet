import SwiftUI
import MapKit
import Combine

// MARK: - MapViewModel

final class MapViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Injectable var locationUseCase: LocationManagerUseCaseProtocol
    @Published var region: MKCoordinateRegion
    private var subscriptions = Set<AnyCancellable>()
    let sources: MapSourcesable.Type

    var place: Place

    // MARK: - Lifecycle

    init(locationUseCase: LocationManagerUseCaseProtocol = LocationManagerUseCase(),
         place: Place = Place(
            name: "",
            latitude: 0,
            longitude: 0),
         sources: MapSourcesable.Type = MapResources.self) {
        self.region = MKCoordinateRegion(
            center: .init(latitude: place.latitude, longitude: place.longitude),
            latitudinalMeters: 650,
            longitudinalMeters: 650
        )
        self.sources = sources
        self.place = place
        self.locationUseCase = locationUseCase
        configPlace()
    }

    // MARK: - Private Properties

    private func configPlace() {
        if place.name.isEmpty && place.latitude == 0 && place.longitude == 0 {
            place = Place(
                name: "",
                latitude: locationUseCase.getUserLocation()?.lat ?? 0,
                longitude: locationUseCase.getUserLocation()?.long ?? 0)
            self.region = MKCoordinateRegion(
                center: .init(latitude: place.latitude,
                              longitude: place.longitude),
                latitudinalMeters: 650,
                longitudinalMeters: 650
            )
        }
    }
}
