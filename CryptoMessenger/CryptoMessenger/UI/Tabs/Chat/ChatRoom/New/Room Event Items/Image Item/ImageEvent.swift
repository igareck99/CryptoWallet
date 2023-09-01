import SwiftUI

struct ImageEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let imageUrl: URL?
    let placeholder: any ViewGeneratable
    let eventData: any ViewGeneratable
    let loadData: any ViewGeneratable
    let onTap: () -> Void

    init(
        imageUrl: URL? = nil,
        placeholder: any ViewGeneratable,
        eventData: any ViewGeneratable,
        loadData: any ViewGeneratable,
        onTap: @escaping () -> Void
    ) {
        self.imageUrl = imageUrl
        self.placeholder = placeholder
        self.eventData = eventData
        self.loadData = loadData
        self.onTap = onTap
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ImageEventView(
            loadData: loadData.view(),
            placeholder: placeholder.view(),
            eventData: eventData.view(),
            model: self
        ).anyView()
    }
}
