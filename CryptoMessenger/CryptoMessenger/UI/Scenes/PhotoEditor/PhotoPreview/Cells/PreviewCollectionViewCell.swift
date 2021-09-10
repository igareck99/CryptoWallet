import UIKit
import SnapKit
import AVFoundation

// MARK: - PreviewCollectionViewCell

final class PreviewCollectionViewCell: UICollectionViewCell & ImageCell {

    // MARK: - Private Properties

    private(set) var imageView = UIImageView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        createConstraints()
        imageView.contentMode = .scaleAspectFit
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageSize = imageView.image?.size else { return }
        let imageRect = AVMakeRect(aspectRatio: imageSize, insideRect: bounds)
        let path = UIBezierPath(rect: imageRect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let attributes = layoutAttributes as? ParallaxLayoutAttributes else {
            return super.apply(layoutAttributes)
        }
        let parallaxValue = attributes.parallaxValue ?? 0
        let transition = -(bounds.width * 0.3 * parallaxValue)
        imageView.transform = CGAffineTransform(translationX: transition, y: .zero)
    }
}
