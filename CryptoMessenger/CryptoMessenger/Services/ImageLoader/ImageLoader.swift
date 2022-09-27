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

	init(
		url: URL?,
		cache: ImageCacheServiceProtocol = ImageCacheService.shared
	) {
		self.url = url
		self.cache = cache
	}

	// MARK: - Internal Methods

	func imageFromCache(imageUrl: URL?) -> UIImage? {
		guard let urlString = imageUrl?.absoluteString else { return nil }
		return cache.imageFromCache(urlKey: urlString)
	}

	func loadImage(imageUrl: URL?) -> UIImage? {
		guard let image = imageFromCache(imageUrl: imageUrl) else {
			load(imageUrl)
			return nil
		}
		return image
	}

	func load(_ imageUrl: URL? = nil) {

		let loadUrl: URL?
		if let iconUrl = imageUrl {
			loadUrl = iconUrl
		} else {
			loadUrl = url
		}

		if let cachedImage = imageFromCache(imageUrl: loadUrl) {
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.image = cachedImage
				self.onFinish()
				self.objectWillChange.send()
			}
			return
		}

		guard let url = loadUrl else { return }
		guard !isLoading else { return }
		self.onStart()
		cache.loadImage(atUrl: url, completion: { [weak self] _, loadedImage in
			guard let self = self else { return }
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.image = loadedImage
				self.onFinish()
				self.objectWillChange.send()
			}
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
