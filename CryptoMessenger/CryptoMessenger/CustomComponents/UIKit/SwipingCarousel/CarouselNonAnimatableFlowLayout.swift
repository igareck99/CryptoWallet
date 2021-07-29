import UIKit

// MARK: - CarouselNonAnimatableFlowLayout

final class CarouselNonAnimatableFlowLayout: CarouselFlowLayout {

    // MARK: - Lifecycle

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
            else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let contentOffsetOrigin = proposedContentOffset.x + collectionView.bounds.size.width * 0.5

        var targetContentOffset: CGPoint
        let contentOffset = layoutAttributes
            .min(by: { abs($0.center.x - contentOffsetOrigin) < abs($1.center.x - contentOffsetOrigin)
            }) ?? UICollectionViewLayoutAttributes()

        targetContentOffset = CGPoint(
            x: contentOffset.center.x - collectionView.bounds.size.width * 0.5,
            y: proposedContentOffset.y
        )

        return targetContentOffset
    }
}
