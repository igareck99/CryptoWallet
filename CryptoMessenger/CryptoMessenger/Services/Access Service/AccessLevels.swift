import Foundation

enum PhotoAccessLevel {
    case authorized
    case denied
    case limited
    case notDetermined
    case restricted
}

enum LocationAccessLevel {
    case restricted
    case notDetermined
    case denied
    case authorizedAlways
    case authorizedWhenInUse
}

enum MediaAccessLevel {
    case notDetermined
    case restricted
    case denied
    case authorized
}
