import UIKit

// MARK: - CarouselConfiguration

protocol CarouselConfiguration {
    var minLineSpacing: CGFloat { get set }
    var cellOffset: CGFloat { get set }
    var zoomLevel: CGFloat { get set }
    var minScalingOffset: CGFloat { get set }
}

// MARK: - CarouselFlowLayout

class CarouselFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Private Properties

    private var minimumSpacing = CGFloat(8)
    private var offset = CGFloat(8)
    private var zoomFactor = CGFloat(1)
    private var scalingOffset = CGFloat(200)
    private var bounds: CGRect { collectionView?.bounds ?? .zero }

    // MARK: - Lifecycle

    override func prepare() {
        super.prepare()

        minimumLineSpacing = minimumSpacing
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = false

        let width: CGFloat = bounds.width - 2 * minimumSpacing - 2 * offset
        itemSize = CGSize(width: width, height: bounds.height)

        let left = (bounds.width - width) * 0.5
        sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
    }

    // MARK: - Internal Methods

    func configureAttributes(for attributes: UICollectionViewLayoutAttributes) {
        guard let collection = collectionView else { return }

        let contentOffset = collection.contentOffset
        let size = collection.bounds.size

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX

        let distanceFromCenter = visibleCenterX - attributes.center.x
        let absDistanceFromCenter = min(abs(distanceFromCenter), scalingOffset)
        let scale = absDistanceFromCenter * (zoomFactor - 1) / scalingOffset + 1

        attributes.zIndex = Int(scale * 100000)
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
}

// MARK: - CarouselFlowLayout (CarouselConfiguration)

extension CarouselFlowLayout: CarouselConfiguration {
    var minLineSpacing: CGFloat {
        get { minimumSpacing }
        set { minimumSpacing = newValue }
    }

    var cellOffset: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    var zoomLevel: CGFloat {
        get { zoomFactor }
        set { zoomFactor = newValue }
    }

    var minScalingOffset: CGFloat {
        get { scalingOffset }
        set { scalingOffset = newValue }
    }
}
