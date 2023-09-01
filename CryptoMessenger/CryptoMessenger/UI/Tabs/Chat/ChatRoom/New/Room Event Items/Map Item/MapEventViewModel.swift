import Foundation
import MapKit
import SwiftUI

final class MapEventViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion = .init()
    var place: Place = .init(name: "", latitude: .zero, longitude: .zero)

    func update(place: Place) {
        self.place = place
        self.region = makeRegion()
    }

    private func makeRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: .init(latitude: place.latitude, longitude: place.longitude),
            latitudinalMeters: 650,
            longitudinalMeters: 650
        )
    }
}
