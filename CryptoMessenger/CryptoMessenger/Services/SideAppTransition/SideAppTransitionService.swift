import UIKit

// swiftlint: disable: all

// MARK: - SideAppTransitionServiceProtocol

protocol SideAppTransitionServiceProtocol {
    func openSideApp(service: GeoService, place: Place)
    func canOpenMapApp(service: GeoService, place: Place) -> Bool
}

// MARK: - SideAppTransitionService

final class SideAppTransitionService: SideAppTransitionServiceProtocol {
    
    // MARK: - Static Properties
    
    static let shared = SideAppTransitionService()

    // MARK: - Internal Methods
    
    func openSideApp(service: GeoService, place: Place) {
        switch service {
        case .baidu:
            openSideAppFromURL(url: URL(string: "baidumap://map/direction?origin = latlng:\(String(describing:LocationManagerUseCase.shared.getLastLocation()?.lat ?? 0)),\(String(describing: LocationManagerUseCase.shared.getLastLocation()?.long ?? 0)) & destination = latlng:\(place.latitude),\(place.longitude) | name = CryptoMessenger & mode = driving & Coord_ type=gcj02"))
        case .apple:
            openSideAppFromURL(url: URL(string: "http://maps.apple.com/maps?daddr=\(place.latitude),\(place.longitude)"))
        case .google:
            openSideAppFromURL(url: URL(string:"https://www.google.com/maps/@\(place.longitude),\(place.longitude),6z"))
        case .yandex:
            openSideAppFromURL(url: URL(string:"yandexmaps://maps.yandex.ru/?pt=\(place.latitude),\(place.longitude)&z=18&l=map"))
        case .doubleGis:
            openSideAppFromURL(url: URL(string:"dgis://2gis.ru/routeSearch/rsType/car/to/55.465508,25.398003"))
        }
    }
    
    func canOpenMapApp(service: GeoService, place: Place) -> Bool {
        switch service {
        case .yandex:
            return checkSharedUrl("yandexmaps://maps.yandex.ru/?pt=\(place.latitude),\(place.longitude)&z=18&l=map")
        case .google:
            return
                checkSharedUrl("https://www.google.com/maps/@\(place.longitude),\(place.longitude),6z")
        case .apple:
            return checkSharedUrl("http://maps.apple.com/maps?daddr=\(place.latitude),\(place.longitude)")
        case .doubleGis:
            return checkSharedUrl("dgis://2gis.ru/geo/\(place.longitude),\(place.latitude)")
        default:
            return false
        }
    }
    
    // MARK: - Internal Methods
    
    private func openSideAppFromURL(url: URL?) {
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    // MARK: - Private Methods
    
    private func checkSharedUrl(_ url: String) -> Bool {
        guard let unwrappedUrl = URL(string: url) else {
            return false
        }
        return UIApplication.shared.canOpenURL(unwrappedUrl)
    }
}
