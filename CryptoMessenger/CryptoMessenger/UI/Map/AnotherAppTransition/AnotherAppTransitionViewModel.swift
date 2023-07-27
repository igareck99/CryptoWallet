import Combine

// MARK: - AnotherApppTransitionViewModel

final class AnotherApppTransitionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var appsList: [AnotherAppData] = []
    @Published var resultAppList: [AnotherAppData] = []
    @Published var place: Place
    @Injectable var sideAppManager: SideAppTransitionServiceProtocol
    let resources: AnotherAppSourcesable.Type

    // MARK: - Lifecycle

    init(place: Place,
         resources: AnotherAppSourcesable.Type = AnotherAppResources.self,
         sideAppManager: SideAppTransitionServiceProtocol = SideAppTransitionService.shared) {
        self.place = place
        self.resources = resources
        self.sideAppManager = sideAppManager
        config()
    }

    // MARK: - Internal Methods

    func getLocationToShare() -> String {
        return "\(place.longitude)  \(place.longitude)"
    }

    // MARK: - Private Methods

    private func config() {
        appsList = [.init(image: resources.appleMapsImage,
                          name: resources.appleMaps,
                          mapsApp: .apple),
                                                     .init(image: resources.googleMapsImage,
                                                           name: resources.googleMaps,
                                                           mapsApp: .google),
                                                     .init(image:  resources.yandexMapsImage,
                                                           name: resources.yandexMaps,
                                                           mapsApp: .yandex),
                                                     .init(image: resources.doubleGisImage,
                                                           name: resources.doubleGis,
                                                           mapsApp: .doubleGis)]
        resultAppList = appsList.filter { sideAppManager.canOpenMapApp(service: $0.mapsApp,
                                                                       place: place) }
    }
}
