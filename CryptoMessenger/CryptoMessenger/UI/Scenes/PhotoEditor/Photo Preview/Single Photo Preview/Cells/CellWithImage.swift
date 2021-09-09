import UIKit

protocol ImageCell: UICollectionViewCell, SnapView {
    var imageView: UIImageView { get }
}

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
