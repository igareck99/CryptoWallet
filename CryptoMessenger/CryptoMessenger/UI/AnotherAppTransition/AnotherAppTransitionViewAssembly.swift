import SwiftUI

enum AnotherAppTransitionViewAssembly {
    static func build(
        place: Place,
        showLocationTransition: Binding<Bool>
    ) -> some View {
        AnotherAppTransitionView(
            showLocationTransition: showLocationTransition,
            viewModel: AnotherApppTransitionViewModel(place: place)
        )
    }
}
