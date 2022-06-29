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

    @Injectable var locationManager: LocationManager

    // MARK: - Lifecycle

    init(locationManager: LocationManager = LocationManagerUseCase.shared) {
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
