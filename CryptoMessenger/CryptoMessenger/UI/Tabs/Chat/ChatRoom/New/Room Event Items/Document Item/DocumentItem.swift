import SwiftUI

// MARK: - DocumentItem

struct DocumentItem: Identifiable, ViewGeneratable {
    let id = UUID()
    let imageName: String
    let title: String
    let size: Int
    let url: URL
    let reactionsGrid: any ViewGeneratable
    let eventData: any ViewGeneratable
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        DocumentItemView(
            eventData: eventData.view(),
            reactions: reactionsGrid.view(),
            viewModel: DocumentItemViewModel(model: self)
        ).anyView()
    }
}
