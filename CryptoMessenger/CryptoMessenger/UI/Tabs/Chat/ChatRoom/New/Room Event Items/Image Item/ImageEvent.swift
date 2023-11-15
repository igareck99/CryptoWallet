import SwiftUI

// MARK: - Image Event

struct ImageEvent: Identifiable, ViewGeneratable {
    let id: UUID
    let imageUrl: URL?
    let size: Int
    let eventData: any ViewGeneratable
    let loadData: any ViewGeneratable
    let onTap: (URL?) -> Void

    init(
        id: UUID = UUID(),
        imageUrl: URL? = nil,
        size: Int,
        eventData: any ViewGeneratable,
        loadData: any ViewGeneratable,
        onTap: @escaping (URL?) -> Void
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.size = size
        self.eventData = eventData
        self.loadData = loadData
        self.onTap = onTap
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ImageEventView(
            loadData: loadData.view(),
            eventData: eventData.view(),
            viewModel: ImageEventViewModel(model: self)
        ).anyView()
    }
}
