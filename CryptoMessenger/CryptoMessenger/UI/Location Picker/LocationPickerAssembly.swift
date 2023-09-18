import Foundation
import SwiftUI

enum LocationPickerAssembly {
    static func build(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: @escaping (Place) -> Void
    ) -> some View {
        let viewModel = MapViewModel(onSendPlace: onSendPlace)
        let view = LocationPickerView(
            place: place,
            sendLocation: sendLocation,
            viewModel: viewModel
        )
        return view
    }
}
