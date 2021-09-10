import UIKit

// MARK: - ImageCell

protocol ImageCell: UICollectionViewCell {
    var imageView: UIImageView { get }
}

// MARK: - ImageCell ()

extension ImageCell {
    func createConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupUI() {
        addSubview(imageView)
        clipsToBounds = true
    }
}
