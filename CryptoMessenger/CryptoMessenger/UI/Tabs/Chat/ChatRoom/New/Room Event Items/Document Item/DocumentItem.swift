import SwiftUI

struct DocumentItem: Identifiable, ViewGeneratable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let url: URL
    let reactionsGrid: any ViewGeneratable
    let eventData: any ViewGeneratable
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        DocumentItemView(
            model: self,
            eventData: eventData.view(),
            reactions: reactionsGrid.view()
        ).anyView()
    }
}
