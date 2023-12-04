import SwiftUI

enum SimpleImageViewerAssembly {
    static func build(imageUrl: URL? = nil, image: Image? = nil) -> some View {
        let viewModel = SimpleImageViewerModel(imageUrl: imageUrl, image: image)
        let view = SimpleImageViewer(viewModel: viewModel)
        return view
    }
}
