import UIKit

// MARK: - ParallaxLayoutAttributes

class ParallaxLayoutAttributes: UICollectionViewLayoutAttributes {
    var parallaxValue: CGFloat?
}

extension ParallaxLayoutAttributes {

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? ParallaxLayoutAttributes
        copy?.parallaxValue = self.parallaxValue
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        let attrs = object as? ParallaxLayoutAttributes
        if attrs?.parallaxValue != parallaxValue {
            return false
        }
        return super.isEqual(object)
    }
}
