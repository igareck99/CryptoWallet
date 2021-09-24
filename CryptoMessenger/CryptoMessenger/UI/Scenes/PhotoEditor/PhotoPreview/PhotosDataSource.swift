import UIKit

// MARK: - PhotosDataSource

final class PhotosDataSource: NSObject {

    // MARK: - Internal Properties

    lazy var images = loadImages()

    // MARK: - Private Properties

    private var urls: [URL] {
        Bundle.main.urls(
            forResourcesWithExtension: .none,
            subdirectory: "Data") ?? []
    }
    private let preview: UICollectionView
    private let thumbnails: UICollectionView

    // MARK: - Lifecycle

    init(preview: UICollectionView, thumbnails: UICollectionView) {
        self.preview = preview
        self.thumbnails = thumbnails
        super.init()
        preview.dataSource = self
        preview.register(
            PreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier
        )
        thumbnails.dataSource = self
        thumbnails.register(
            ThumbnailCollectionViewCell.self,
            forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
    }

    // MARK: - Internal Methods

    func loadImages() -> [UIImage] {
        urls
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap(UIImage.init(data:))
    }
}

// MARK: - PhotosDataSource (UICollectionViewDataSource)

extension PhotosDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseId: String?
        if collectionView == preview {
            reuseId = PreviewCollectionViewCell.identifier
        }
        if collectionView == thumbnails {
            reuseId = ThumbnailCollectionViewCell.identifier
        }
        let cell = reuseId.flatMap {
            collectionView.dequeueReusableCell(
                withReuseIdentifier: $0,
                for: indexPath) as? ImageCell
        }
        cell?.imageView.image = images[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}
