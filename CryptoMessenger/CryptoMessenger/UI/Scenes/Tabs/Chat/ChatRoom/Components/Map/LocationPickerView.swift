import UIKit
import MapKit
import SwiftUI

//swiftlint: disable all

// MARK: - LocationPickerView

struct LocationPickerView: View {

    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss

    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var locationTemp = Place(name: "", latitude: 0, longitude: 0)
    @State private var address: String = ""
    @State private var searching = false
    @State private var isInteractionModesDisabled: Bool = false

    private let locationPickerBaidu: LocationPickerBaidu
    
    @Binding var sendLocation: Bool
    @Binding var place: Place?
    @StateObject var viewModel: MapViewModel
    

    // MARK: - Lifecycle

    init(
		place: Binding<Place?>,
        sendLocation: Binding<Bool>,
		isInteractionModesDisabled: Bool = false,
        locationUseCase: LocationManagerUseCase = LocationManagerUseCase(),
		locationPickerBaidu: LocationPickerBaidu = LocationPickerBaidu()
	) {
        self._viewModel = StateObject(wrappedValue: MapViewModel())
		self.locationPickerBaidu = locationPickerBaidu
        self._place = place
        self._sendLocation = sendLocation
    }
    
    private func configData() {
        self.locationTemp = Place(name: "User", latitude: viewModel.locationUseCase.getUserLocation()?.lat ?? 0, longitude: viewModel.locationUseCase.getUserLocation()?.long ?? 0)
        self.viewModel.region = MKCoordinateRegion(center:
                                            CLLocationCoordinate2D(
                                                latitude: viewModel.locationUseCase.getUserLocation()?.lat ?? 0,
                                                longitude: viewModel.locationUseCase.getUserLocation()?.long ?? 0),
                                         span:
                                            MKCoordinateSpan(
                                                latitudeDelta: 0.01,
                                                longitudeDelta: 0.01))
    }

	private func updateBaiduMap() {
        guard let location = viewModel.locationUseCase.getUserLocation() else { return }
		let location2D = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
		locationPickerBaidu.update(coordinates: location2D)
	}

    // MARK: - Body

    var body: some View {
        VStack {
            switch viewModel.locationUseCase.getCountry() {
            case .china:
                locationPickerBaidu
                .frame(width: UIScreen.main.bounds.width, height: 196, alignment: .leading)
                Spacer()
                HStack {
                    Button(action: {
                        self.place = locationTemp
                        dismiss()
                    }) {
                        Label(viewModel.sources.locationPickerViewLocation,
                              image: viewModel.sources.markerString)
                    }
                }.padding()
            case .other:
                HStack {
                    SearchBar(
                        placeholder: viewModel.sources.locationPickerViewSearchPlaceholder,
                        searchText: $address,
                        searching: $searching
                    )
                    .onReceive(viewModel.$region, perform: { value in
                        DispatchQueue.main.async {
                            self.place = Place(name: "",
                                               latitude: value.center.latitude,
                                               longitude: value.center.longitude)
                            self.locationTemp  = self.place ?? Place(name: "",
                                                                     latitude: 0,
                                                                     longitude: 0)
                        }
                    })
                    .onReceive(address.publisher.delay(for: 1, scheduler: DispatchQueue.main)) { location in
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
                            guard
                                let placemarks = placemarks,
                                let location = placemarks.first?.location
                            else {
                                return
                            }
                            self.locationTemp = Place(name: address, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            self.viewModel.region = MKCoordinateRegion(center:
                                                                CLLocationCoordinate2D(
                                                                    latitude: location.coordinate.latitude ,
                                                                    longitude: location.coordinate.longitude ),
                                                             span:
                                                                MKCoordinateSpan(
                                                                    latitudeDelta: 0.01,
                                                                    longitudeDelta: 0.01))
                        }
                    }
                    Button(viewModel.sources.createActionCancel, action: {
                        dismiss()
                    })
                }
                .cornerRadius(3)
                .padding([.horizontal, .top], 15)
                ZStack(alignment: .center) {
                    Map(
                        coordinateRegion: $viewModel.region,
                        interactionModes: isInteractionModesDisabled ? [] : .all,
                        showsUserLocation: false,
                        annotationItems: [self.locationTemp]
                    ) { place in
                        MapAnnotation(
                            coordinate: .init(latitude: place.latitude, longitude: place.longitude),
                            anchorPoint: CGPoint(x: 0.01, y: 0.01)
                        ) {
                        }
                    }
                    viewModel.sources.marker
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.width,
                       alignment: .leading)
                HStack {
                    Button(action: {
                        self.sendLocation = true
                        self.place = locationTemp
                        dismiss()
                    }) {
                        Label(viewModel.sources.locationPickerViewLocation,
                              image: viewModel.sources.markerString)
                    }
                }.padding()
                Spacer()
            }
        }
        .onAppear {
            sendLocation = false
            configData()
            switch self.viewModel.locationUseCase.getCountry() {
            case .china:
                updateBaiduMap()
            case .other:
                self.isInteractionModesDisabled = isInteractionModesDisabled
            }
        }
        .navigationBarHidden(true)
    }
}
