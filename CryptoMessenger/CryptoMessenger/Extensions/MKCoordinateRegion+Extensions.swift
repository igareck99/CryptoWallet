import MapKit

extension MKCoordinateRegion {
    static func regionFrom(
        place: Place,
        latMeters: CLLocationDistance = 650.0,
        lonMeters: CLLocationDistance = 650.0
    ) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: place.center(),
            latitudinalMeters: latMeters,
            longitudinalMeters: lonMeters
        )
    }
}
