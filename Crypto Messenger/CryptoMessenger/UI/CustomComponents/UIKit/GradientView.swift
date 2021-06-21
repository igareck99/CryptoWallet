import UIKit

// MARK: GradientView

final class GradientView: UIView {

    // MARK: - Internal Properties

    var gradientColors: [UIColor] = []

    // MARK: - Lifecycle

    override class var layerClass: AnyClass { CAGradientLayer.self }

    override func layoutSubviews() {
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
        gradientLayer?.locations = [0, 1]
        gradientLayer?.startPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer?.endPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer?.shouldRasterize = true
    }
}
