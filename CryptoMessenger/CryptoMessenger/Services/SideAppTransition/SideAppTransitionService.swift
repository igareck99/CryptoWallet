import Foundation

// swiftlint: disable: all

// MARK: - SideAppTransitionServiceProtocol

protocol SideAppTransitionServiceProtocol {
    func openSideApp(service: GeoService, place: Place)
}

// MARK: - SideAppTransitionService

final class SideAppTransitionService: SideAppTransitionServiceProtocol {
    
    // MARK: - Static Properties
    
    static let shared = SideAppTransitionService()

    // MARK: - Internal Methods
    
    func openSideApp(service: GeoService, place: Place) {
        switch service {
        case .baidu:
            debugPrint(URL(string: "baidumap://map/direction?origin = latlng:\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0)) & destination = latlng:\(place.latitude),\(place.longitude) | name = CryptoMessenger & mode = driving & Coord_ type=gcj02"))
            openSideAppFromURL(url: URL(string: "baidumap://map/direction?origin = latlng:\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0)) & destination = latlng:\(place.latitude),\(place.longitude) | name = CryptoMessenger & mode = driving & Coord_ type=gcj02"))
        case .apple:
            debugPrint("Apple maps", URL(string: "http://maps.apple.com/maps?saddr=\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0))&daddr=\(place.latitude),\(place.longitude)"))
            openSideAppFromURL(url: URL(string: "http://maps.apple.com/maps?saddr=\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0))&daddr=\(place.latitude),\(place.longitude)"))
        case .google:
            debugPrint(URL(string: "comgooglemaps-x-callback://?saddr=\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0))&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving"))
            openSideAppFromURL(url: URL(string: "comgooglemaps-x-callback://?saddr=\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0))&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving"))
        }
    }
    
    // MARK: - Internal Methods
    
    private func openSideAppFromURL(url: URL?) {
        if let url = url {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
