import SwiftUI

// MARK: - MapSnapshotViewModel

final class MapSnapshotViewModel: ObservableObject {

    // MARK: - MapService

    enum MapService {
        case apple
        case waze
        case google
        case baidu
    }

    // MARK: - Internal Properties

    @Injectable var locationManager: LocationManagerUseCaseProtocol

    // MARK: - Lifecycle

    init(locationManager: LocationManagerUseCaseProtocol = LocationManagerUseCase()) {
        self.locationManager = locationManager
    }

    // MARK: - Internal Methods

    func mapsService() -> MapService {
        switch locationManager.getCountry() {
        case .china:
            return MapService.baidu
        case .other:
            return MapService.apple
        }
    }
}
