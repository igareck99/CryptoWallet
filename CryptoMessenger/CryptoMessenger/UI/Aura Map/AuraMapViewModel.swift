import Combine
import MapKit
import SwiftUI

protocol AuraMapViewModelDelegate: AnyObject {
    func didTapOpenOtherAppView(
        place: Place,
        showLocationTransition: Binding<Bool>
    )
}

protocol AuraMapViewModelProtocol: ObservableObject {
    var place: Place { get }
    var region: MKCoordinateRegion { get set }
    var isInteractionModesDisabled: Bool { get }

    func didTapAnnotation()
    func didTapOpenPlaceInOtherApp()
}

final class AuraMapViewModel: ObservableObject {

    @Published var place: Place = .zero
    @Published var region: MKCoordinateRegion
    private var subscriptions = Set<AnyCancellable>()
    private let locationUseCase: LocationManagerUseCaseProtocol
    private let sources: AuraMapSourcesable.Type
    weak var delegate: AuraMapViewModelDelegate?
    var isInteractionModesDisabled = false

    init(
        place: Place,
        delegate: AuraMapViewModelDelegate? = nil,
        locationUseCase: LocationManagerUseCaseProtocol = LocationManagerUseCase(),
        sources: AuraMapSourcesable.Type = AuraMapSources.self
    ) {
        self.delegate = delegate
        self.region = .regionFrom(place: place)
        self.sources = sources
        self.place = place
        self.locationUseCase = locationUseCase
        configDefaultPlace()
    }

    private func configDefaultPlace() {
        guard place.name.isEmpty &&
                place.latitude == 0 &&
                place.longitude == 0 else { return }
        place = Place(
            name: "",
            latitude: locationUseCase.getUserLocation()?.lat ?? 0,
            longitude: locationUseCase.getUserLocation()?.long ?? 0
        )
        self.region = .regionFrom(place: place)
    }
}

// MARK: - AuraMapViewModelProtocol

extension AuraMapViewModel: AuraMapViewModelProtocol {
    func didTapAnnotation() {
        delegate?.didTapOpenOtherAppView(place: place, showLocationTransition: .constant(false))
    }

    func didTapOpenPlaceInOtherApp() {
        delegate?.didTapOpenOtherAppView(place: place, showLocationTransition: .constant(false))
    }
}
