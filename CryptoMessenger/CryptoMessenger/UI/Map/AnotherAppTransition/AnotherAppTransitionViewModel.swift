import Combine

// MARK: - AnotherApppTransitionViewModel

final class AnotherApppTransitionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var appsList: [AnotherAppData] = []
    @Published var resultAppList: [AnotherAppData] = []
    @Published var place: Place
    @Injectable var sideAppManager: SideAppTransitionServiceProtocol
    let sources: AnotherAppSourcesable.Type

    // MARK: - Lifecycle

    init(place: Place,
         sources: AnotherAppSourcesable.Type = AnotherAppResources.self,
         sideAppManager: SideAppTransitionServiceProtocol = SideAppTransitionService.shared) {
        self.place = place
        self.sources = sources
        self.sideAppManager = sideAppManager
        config()
    }

    // MARK: - Internal Methods

    func getLocationToShare() -> String {
        return "\(place.longitude)  \(place.longitude)"
    }

    // MARK: - Private Methods

    private func config() {
        appsList = [.init(image: sources.appleMapsImage,
                          name: sources.appleMaps,
                          mapsApp: .apple),
                                                     .init(image: sources.googleMapsImage,
                                                           name: sources.googleMaps,
                                                           mapsApp: .google),
                                                     .init(image:  sources.yandexMapsImage,
                                                           name: sources.yandexMaps,
                                                           mapsApp: .yandex),
                                                     .init(image: sources.doubleGisImage,
                                                           name: sources.doubleGis,
                                                           mapsApp: .doubleGis)]
        resultAppList = appsList.filter { sideAppManager.canOpenMapApp(service: $0.mapsApp,
                                                                       place: place) }
    }
}
