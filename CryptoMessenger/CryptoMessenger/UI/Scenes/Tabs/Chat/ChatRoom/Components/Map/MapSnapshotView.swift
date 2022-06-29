import MapKit
import SwiftUI

// MARK: - MapSnapshotView

struct MapSnapshotView: View {

    // MARK: - Internal Properties

    let latitude: Double
    let longitude: Double
    var span: CLLocationDegrees = 0.01
    private var viewModel: MapSnapshotViewModel

    // MARK: - Private Properties

    @State private var snapshotImage: UIImage?

    init(latitude: Double, longitude: Double) {
        viewModel = MapSnapshotViewModel()
        self.latitude = latitude
        self.longitude = longitude
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            Group {
                if let image = snapshotImage {
                    ZStack {
                        Image(uiImage: image)

                        ZStack {
                            R.image.chat.location.marker.image
                        }
                    }
                } else {
                    VStack {
                        Spacer()

                        HStack {
                            Spacer()
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }

                        Spacer()
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .onAppear {
                switch viewModel.mapsService() {
                case .baidu:
                    generateBaiduSnapshot(width: geometry.size.width, height: geometry.size.height)
                case .apple:
                    generateAppleMapsSnapshot(width: geometry.size.width, height: geometry.size.height)
                case .waze:
                    break
                case .google:
                    break
                }
            }
        }
    }

    // MARK: - Private Methods

    private func generateAppleMapsSnapshot(width: CGFloat, height: CGFloat) {
        let region = MKCoordinateRegion(
            center: .init(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        )

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: width, height: height)
        options.showsBuildings = true

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let snapshot = snapshot {
                snapshotImage = snapshot.image
            }
        }
    }

    // TODO: Adatp with baidu service
    private func generateBaiduSnapshot(width: CGFloat, height: CGFloat) {
        let region = MKCoordinateRegion(
            center: .init(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        )

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: width, height: height)
        options.showsBuildings = true

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let snapshot = snapshot {
                snapshotImage = snapshot.image
            }
        }
    }
}
