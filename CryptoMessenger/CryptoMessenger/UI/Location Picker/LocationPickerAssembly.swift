import Foundation
import SwiftUI

enum LocationPickerAssembly {
    static func build(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    ) -> some View {
        LocationPickerView(
            place: place,
            sendLocation: sendLocation
        )
    }
}
