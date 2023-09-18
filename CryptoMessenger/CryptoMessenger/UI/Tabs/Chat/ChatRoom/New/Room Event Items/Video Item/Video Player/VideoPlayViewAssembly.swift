import SwiftUI

enum VideoPlayViewAssembly {
    static func build(videoUrl: URL) -> some View {
        let viewModel = VideoPlayerViewModel(videoUrl: videoUrl)
        let view = VideoPlayView(viewModel: viewModel)
        return view
    }
}
