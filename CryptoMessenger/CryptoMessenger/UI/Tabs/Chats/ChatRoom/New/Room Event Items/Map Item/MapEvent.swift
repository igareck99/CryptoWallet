import SwiftUI

struct MapEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let place: Place
    let eventData: any ViewGeneratable
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        MapEventView(
            model: self,
            eventData: eventData.view()
        )
            .anyView()
    }
}
