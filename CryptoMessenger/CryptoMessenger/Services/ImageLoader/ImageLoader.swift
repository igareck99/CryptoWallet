import Combine
import UIKit

// MARK: - ImageLoader

final class ImageLoader: ObservableObject {

    // MARK: - Internal Properties

    var url: URL?

    @Published var image: UIImage?
    private(set) var isLoading = false

    // MARK: - Private Properties

    @Injectable private var cache: ImageCacheServiceProtocol

    // MARK: - Lifecycle

    init(url: URL?, cache: ImageCacheServiceProtocol = ImageCacheService()) {
        self.url = url
        self.cache = cache
    }

    // MARK: - Internal Methods

    func load() {
        guard let url = url else { return }
        guard !isLoading else { return }
        self.onStart()
        cache.loadImage(atUrl: url, completion: { _, image in
            self.image = image
            self.onFinish()
            })
    }

    // MARK: - Private Methods

    private func onStart() {
        isLoading = true
    }

    private func onFinish() {
        isLoading = false
    }
}
