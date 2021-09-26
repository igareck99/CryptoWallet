import UIKit

// MARK: - PhotosDataSource

final class PhotosDataSource: NSObject {

    // MARK: - Internal Properties

    private(set) var images: [UIImage] = []

    // MARK: - Private Properties

    private let preview: UICollectionView
    private let thumbnails: UICollectionView

    // MARK: - Lifecycle

    init(preview: UICollectionView, thumbnails: UICollectionView, images: [UIImage]) {
        self.preview = preview
        self.thumbnails = thumbnails
        self.images = images
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

    func setImages(_ images: [UIImage]) {
        self.images = images
    }

    func removeImage(at index: Int) {
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
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
