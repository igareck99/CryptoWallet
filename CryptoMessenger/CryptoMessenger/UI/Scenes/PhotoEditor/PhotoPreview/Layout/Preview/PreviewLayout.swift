import UIKit

// MARK: - PreviewLayout

final class PreviewLayout: UICollectionViewFlowLayout {

    // MARK: - Internal properties

    let offsetBetweenCells: CGFloat = 44
    var layoutHandler: LayoutChangeHandler?

    // MARK: - Lifecycle

    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PreviewLayout (UICollectionViewFlowLayout)

extension PreviewLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }

    override class var layoutAttributesClass: AnyClass { ParallaxLayoutAttributes.self }

    override func prepare() {
        super.prepare()
        if let collectionView = collectionView, let layoutHandler = layoutHandler {
            let size = collectionView.bounds.size
            if size != itemSize {
                itemSize = size
                invalidateLayout()
            }
            if layoutHandler.needsUpdateOffset {
                let offset = collectionView.contentOffset
                collectionView.contentOffset = targetContentOffset(forProposedContentOffset: offset)
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? ParallaxLayoutAttributes }
            .compactMap(prepareAttributes)
    }

    private func prepareAttributes(attributes: ParallaxLayoutAttributes) -> ParallaxLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }

        let width = itemSize.width
        let centerX = width * 0.5
        let distanceToCenter = attributes.center.x - collectionView.contentOffset.x
        let relativeDistanceToCenter = (distanceToCenter - centerX) / width

        if abs(relativeDistanceToCenter) >= 1 {
            attributes.parallaxValue = .none
            attributes.transform = .identity
        } else {
            attributes.parallaxValue = relativeDistanceToCenter
            attributes.transform = CGAffineTransform(translationX: relativeDistanceToCenter * offsetBetweenCells, y: 0)
        }
        return attributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let targetOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        guard let layoutHandler = layoutHandler, layoutHandler.needsUpdateOffset else { return targetOffset }
        return CGPoint(
            x: CGFloat(layoutHandler.targetIndex) * itemSize.width,
            y: targetOffset.y
        )
    }
}
