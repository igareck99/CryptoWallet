import SwiftUI

enum AuraMapViewAssembly {
    static func build(
        place: Place,
        delegate: AuraMapViewModelDelegate?
    ) -> some View {
        let viewModel = AuraMapViewModel(
            place: place,
            delegate: delegate
        )
        let view = AuraMapView(viewModel: viewModel)
        return view
    }
}
