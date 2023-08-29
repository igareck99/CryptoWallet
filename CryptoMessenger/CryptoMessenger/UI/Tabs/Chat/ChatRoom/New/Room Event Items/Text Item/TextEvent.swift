import SwiftUI

struct TextEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let text: String
    let eventData: any ViewGeneratable
    let reactionsGrid: any ViewGeneratable

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        TextEventView(
            model: self,
            eventData: eventData.view(),
            reactions: reactionsGrid.view()
        )
        .anyView()
    }
}
