import UIKit

// MARK: - ThumbnailCollectionViewCell

final class ThumbnailCollectionViewCell: UICollectionViewCell & ImageCell {

    // MARK: - Private Properties

    private(set) var imageView = UIImageView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        createConstraints()
        imageView.contentMode = .scaleAspectFill
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
