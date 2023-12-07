import SwiftUI

struct VideoEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let videoUrl: URL?
    let thumbnailurl: URL?
    let size: Int
    let placeholder: any ViewGeneratable
    let eventData: any ViewGeneratable
    let loadData: any ViewGeneratable
    let onTap: (URL) -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        let viewModel = VideoEventViewModel(model: self)
        VideoEventView(
            viewModel: viewModel,
            loadData: loadData.view(),
            placeholder: placeholder.view(),
            eventData: eventData.view()
        ).anyView()
    }
}
