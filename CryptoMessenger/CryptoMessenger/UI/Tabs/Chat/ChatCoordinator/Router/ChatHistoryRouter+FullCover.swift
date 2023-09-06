import Foundation
import SwiftUI

extension ChatHistoryRouter {
    @ViewBuilder
    func fullScreenSheetContent(item: ChatHistoryFullCoverLink) -> some View {
        switch item {
        case let .imageViewer(imageUrl):
            SimpleImageViewerAssembly.build(imageUrl: imageUrl)
        case let .video(url):
            VideoPlayViewAssembly.build(videoUrl: url)
        default: EmptyView()
        }
    }
}
