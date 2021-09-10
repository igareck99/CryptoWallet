import UIKit

// MARK: - ParallaxLayoutAttributes

class ParallaxLayoutAttributes: UICollectionViewLayoutAttributes {

    // MARK: - Internal Properties

    var parallaxValue: CGFloat?

    // MARK: - Internal Methods

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? ParallaxLayoutAttributes
        copy?.parallaxValue = self.parallaxValue
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        let attributes = object as? ParallaxLayoutAttributes
        guard attributes?.parallaxValue == parallaxValue else { return super.isEqual(object) }
        return false
    }
}
