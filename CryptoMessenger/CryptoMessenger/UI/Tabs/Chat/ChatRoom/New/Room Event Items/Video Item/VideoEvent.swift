import SwiftUI

struct VideoEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let videoUrl: URL?
    let placeholder: any ViewGeneratable
    let eventData: any ViewGeneratable
    let loadData: any ViewGeneratable
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        VideoEventView(
            model: self,
            loadData: loadData.view(),
            placeholder: placeholder.view(),
            eventData: eventData.view()
        ).anyView()
    }
}
