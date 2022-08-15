import UIKit
import MapKit
import SwiftUI

//swiftlint: disable all

// MARK: - MapView

struct LocationPickerView: View {
    // MARK: - Private Properties
    @Environment(\.dismiss) private var dismiss

    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center:
                                                                        CLLocationCoordinate2D(
                                                                            latitude: LocationManagerUseCase.shared.getUserLocation()?.lat ?? 0,
                                                                            longitude: LocationManagerUseCase.shared.getUserLocation()?.long ?? 0),
                                                                     span:
                                                                        MKCoordinateSpan(
                                                                            latitudeDelta: 0.01,
                                                                            longitudeDelta: 0.01))
    @State private var locationTemp: Place = Place(name: "User", latitude: LocationManagerUseCase.shared.getUserLocation()?.lat ?? 0, longitude: LocationManagerUseCase.shared.getUserLocation()?.long ?? 0)
    @State private var address: String = ""
    @State private var searching = false

    private let locationPickerBaidu: LocationPickerBaidu

    @Binding var place: Place?
    
    private var isInteractionModesDisabled: Bool = false
    private(set) var viewModel: MapViewModel
    

    // MARK: - Lifecycle

    init(
		place: Binding<Place?>,
		isInteractionModesDisabled: Bool = false,
		locationManager: LocationServiceProtocol = LocationManagerUseCase.shared,
		locationPickerBaidu: LocationPickerBaidu = LocationPickerBaidu()
	) {
        self.viewModel = MapViewModel(locationManager: locationManager, place: Place(
            name: "",
            latitude: LocationManagerUseCase.shared.lastLocation?.lat ?? 0,
            longitude: LocationManagerUseCase.shared.lastLocation?.lat ?? 0))

		self.locationPickerBaidu = locationPickerBaidu

        self._place = place
        switch self.viewModel.locationManager.getCountry() {
        case .china:
			updateBaiduMap()
        case .other:
            self.isInteractionModesDisabled = isInteractionModesDisabled
        }
    }

	private func updateBaiduMap() {
		guard let location = viewModel.locationManager.getUserLocation() else { return }
		let location2D = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
		locationPickerBaidu.update(coordinates: location2D)
	}

    // MARK: - Body

    var body: some View {
        VStack {
            switch LocationManagerUseCase.shared.country {
            case .china:
                locationPickerBaidu
                .frame(width: UIScreen.main.bounds.width, height: 196, alignment: .leading)
                Spacer()
                HStack {
                    Button(action: {
                        self.place = locationTemp
                        dismiss()
                    }) {
                        Label(R.string.localizable.locationPickerViewLocation(), image: "Chat/Location/marker")
                    }
                }.padding()
            case .other:
                HStack {
                    SearchBar(
                        placeholder: R.string.localizable.locationPickerViewSearchPlaceholder(),
                        searchText: $address,
                        searching: $searching
                    )
                    .onReceive(address.publisher.delay(for: 2, scheduler: DispatchQueue.main)) { location in
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
                            guard
                                let placemarks = placemarks,
                                let location = placemarks.first?.location
                            else {
                                return
                            }
                            self.locationTemp = Place(name: address, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            self.region = MKCoordinateRegion(center:
                                                                CLLocationCoordinate2D(
                                                                    latitude: location.coordinate.latitude ,
                                                                    longitude: location.coordinate.longitude ),
                                                             span:
                                                                MKCoordinateSpan(
                                                                    latitudeDelta: 0.01,
                                                                    longitudeDelta: 0.01))
                        }
                    }
                    Button(R.string.localizable.createActionCancel(), action: {
                        dismiss()
                    })
                }
                .cornerRadius(3)
                .padding([.horizontal, .top], 15)
                Map(
                    coordinateRegion: $region,
                    interactionModes: isInteractionModesDisabled ? [] : .all,
                    showsUserLocation: false,
                    annotationItems: [self.locationTemp]
                ) { place in
                    MapAnnotation(
                        coordinate: .init(latitude: place.latitude, longitude: place.longitude),
                        anchorPoint: CGPoint(x: 0.01, y: 0.01)
                    ) {
                        R.image.chat.location.marker.image
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .leading)
                HStack {
                    Button(action: {
                        self.place = locationTemp
                        dismiss()
                    }) {
                        Label(R.string.localizable.locationPickerViewLocation(), image: "Chat/Location/marker")
                    }
                }.padding()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
