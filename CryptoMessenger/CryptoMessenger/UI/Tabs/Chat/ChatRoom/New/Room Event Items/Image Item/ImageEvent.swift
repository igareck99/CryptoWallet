import SwiftUI

// MARK: - Image Event

typealias ImageEventTap = (Image?, URL?) -> Void

struct ImageEvent: Identifiable, ViewGeneratable {
    let id: UUID
    let imageUrl: URL?
    let size: Int
    let sentState: RoomSentState
    let eventData: any ViewGeneratable
    let loadData: any ViewGeneratable
    let onTap: ImageEventTap

    init(
        id: UUID = UUID(),
        imageUrl: URL? = nil,
        size: Int,
        sentState: RoomSentState,
        eventData: any ViewGeneratable,
        loadData: any ViewGeneratable,
        onTap: @escaping ImageEventTap
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.size = size
        self.sentState = sentState
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
