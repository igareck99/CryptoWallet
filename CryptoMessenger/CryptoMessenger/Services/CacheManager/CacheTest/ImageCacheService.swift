import UIKit

// MARK: - ImageCacheServiceprotocol

protocol ImageCacheServiceProtocol {

	func imageFromCache(urlKey: String) -> UIImage?
	
    func loadImage(
		atUrl url: URL,
		completion: @escaping (String, UIImage?) -> Void
	)
    func clearLocalCache()
}

// MARK: - ImageCacheServiceprotocol

final class ImageCacheService: ImageCacheServiceProtocol {
    
    // MARK: - Private Properties

	static let shared = ImageCacheService()

    private let autoCleanupDays = 30
    private var lastCleanup = UserDefaults.standard.object(forKey: "lastCleanup") as? Date ?? Date() {
        didSet {
            UserDefaults.standard.set(lastCleanup, forKey: "lastCleanup")
        }
    }
    private let queue = DispatchQueue(label: "ImageCache")
    private var workItems = NSCache<NSString, DispatchWorkItem>()
    private var images = NSCache<NSString, UIImage>()
    private var cacheType = CacheType.disk
    
    // MARK: - Internal Methods

	func imageFromCache(urlKey: String) -> UIImage? {
		guard let image = images.object(forKey: urlKey as NSString) else { return nil }
		return image
	}

    func loadImage(
		atUrl url: URL,
		completion: @escaping (String, UIImage?) -> Void
	) {
        let urlString = url.absoluteString
        let key = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? urlString
        DispatchQueue(label: "LoadImageQueue").async { [weak self] in
			guard let self = self else {
				completion(urlString, nil)
                return
            }
            if let image = self.image(of: key) {
                DispatchQueue.main.async {
                    completion(urlString, image)
                }
                return
            }
            if let workItem = self.workItems.object(forKey: key as NSString) {
                workItem.notify(queue: DispatchQueue(label: "NotifyQueue"), execute: { [weak self] in
                    if let image = self?.image(of: key) {
                        DispatchQueue.main.async {
                            completion(urlString, image)
                        }
                    }
                })
                return
            }
            let workItem = DispatchWorkItem { [weak self] in
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completion(urlString, image)
                        }
                        DispatchQueue.global(qos: .utility).async {
                            self?.cacheImage(data: data, key: key)
                        }
                        return
                    }
					completion(urlString, nil)
                }
                .resume()
            }
            self.workItems.setObject(workItem, forKey: key as NSString)
            self.queue.async(execute: workItem)
        }
    }

    func clearLocalCache() {
        let fileManager = FileManager.default
        let imageDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        if Date().timeIntervalSince(lastCleanup) > TimeInterval(autoCleanupDays * 24 * 3600) {
            if fileManager.isDeletableFile(atPath: imageDirectory.path) {
                do {
                    try fileManager.removeItem(atPath: imageDirectory.path)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            lastCleanup = Date()
        }
        workItems.removeAllObjects()
        images.removeAllObjects()
    }

    // MARK: - Private Methods

    private func image(of url: URL, fileSize size: CGSize? = nil) -> UIImage? {
        let urlString = url.absoluteString
        let key = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? urlString
        return image(of: key, fitSize: size)
    }

    private func image(of key: String, fitSize size: CGSize? = nil) -> UIImage? {
        if let image = images.object(forKey: key as NSString) {
            return image
        }
        let fileURL = cacheFileUrl(key)
        do {
            let data = try Data(contentsOf: fileURL)
            let image = UIImage(data: data)
            return size != nil ? image?.scaleToFit(in: size!) : image
        } catch {
        }
        return nil
    }

    private func cacheImage(_ image: UIImage, key: String) {
        switch cacheType {
        case .ram:
            images.setObject(image, forKey: key as NSString)
        case .disk:
            if let data = image.pngData() {
                let fileURL = cacheFileUrl(key)
                do {
                    try data.write(to: fileURL, options: Data.WritingOptions.atomic)
                } catch {
                    debugPrint("Error write file \(error.localizedDescription)")
                }
            }
        }
    }

    private func cacheImage(data: Data, key: String) {
        switch cacheType {
        case .ram:
            if let image = UIImage(data: data) {
                images.setObject(image, forKey: key as NSString)
            }
        case .disk:
            let fileURL = cacheFileUrl(key)
            do {
                try data.write(to: fileURL, options: Data.WritingOptions.atomic)
            } catch {
                debugPrint("Error write file \(error.localizedDescription)")
            }
        }
    }
    
    private func set(image: UIImage, key: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        cacheImage(data: data, key: key)
    }
}
