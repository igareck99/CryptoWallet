import UIKit

// MARK: - CarouselCollectionView

final class CarouselCollectionView: UICollectionView {

    // MARK: - Lifecycle

    init() {
        let carouselFlowLayout = CarouselAnimatableFlowLayout()
        carouselFlowLayout.cellOffset = 16
        carouselFlowLayout.minLineSpacing = 4
        carouselFlowLayout.zoomLevel = 0.93

        super.init(frame: .zero, collectionViewLayout: carouselFlowLayout)

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        decelerationRate = .fast
        collectionViewLayout = carouselFlowLayout
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
