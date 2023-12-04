import SwiftUI

protocol SimpleImageViewerModelProtocol: ObservableObject {
    var image: Image? { get set }
}

final class SimpleImageViewerModel {
    @Published var imageUrl: URL?
    @Published var image: Image?
    private let imageLoader: ImageLoader

    init(
        imageUrl: URL? = nil,
        image: Image? = nil,
        imageLoader: ImageLoader = ImageLoader()
    ) {
        self.imageUrl = imageUrl
        self.image = image
        self.imageLoader = imageLoader
        loadImageIfNeeded()
    }

    private func loadImageIfNeeded() {
        guard image == nil else { return }
        guard let url = imageUrl else { return }
        Task {
            let result = await imageLoader.loadImage(url: url)
            guard let img = result else { return }
            await MainActor.run {
                image = img
            }
        }
    }
}

// MARK: - SimpleImageViewerModelProtocol

extension SimpleImageViewerModel: SimpleImageViewerModelProtocol {

}
