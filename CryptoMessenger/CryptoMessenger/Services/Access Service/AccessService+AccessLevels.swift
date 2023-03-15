import Foundation
import Photos

extension AccessService {

    func photoAccessLevel(from status: PHAuthorizationStatus) -> PhotoAccessLevel {
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .limited:
            return .limited
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        @unknown default:
            return .notDetermined
        }
    }

    func locationAccessLevel(from status: CLAuthorizationStatus) -> LocationAccessLevel {
        switch status {
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorizedAlways:
            return .authorizedAlways
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        @unknown default:
            return .notDetermined
        }
    }

    func mediaAccessLevel(from status: AVAuthorizationStatus) -> MediaAccessLevel {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
}
