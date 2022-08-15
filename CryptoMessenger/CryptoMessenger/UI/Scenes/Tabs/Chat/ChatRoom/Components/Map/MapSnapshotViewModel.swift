import SwiftUI

// MARK: - MapSnapshotViewModel

final class MapSnapshotViewModel: ObservableObject {
    enum MapService {
        case apple
        case waze
        case google
        case baidu
    }

    // MARK: - Internal Properties

    @Injectable var locationManager: LocationServiceProtocol

    // MARK: - Lifecycle

    init(locationManager: LocationServiceProtocol = LocationManagerUseCase.shared) {
        self.locationManager = locationManager
    }

    func mapsService() -> MapService {
        switch locationManager.getCountry() {
        case .china:
            return MapService.baidu
        case .other:
            return MapService.apple
        }
    }
}
