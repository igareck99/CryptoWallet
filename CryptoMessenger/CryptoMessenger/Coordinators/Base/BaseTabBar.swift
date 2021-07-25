import UIKit

// MARK: - BaseTabBar

final class BaseTabBar: UITabBar {

    // MARK: - Internal Properties

    var onHideTabBar: ((Bool) -> Void)?

    override var isHidden: Bool {
        didSet { onHideTabBar?(isHidden) }
    }

    // MARK: - Private Properties

    private var tabBarHeight: CGFloat { 88 }

    private var circleLayer: CAShapeLayer?
    private var holeLayer: CAShapeLayer?
    private var curveView: UIView?

    private var shapeLayer: CALayer?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sizeThatFits = super.sizeThatFits(size)
        return CGSize(width: sizeThatFits.width, height: tabBarHeight)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupTabBar()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addShape()
    }
}

// MARK: - BaseTabBar ()

private extension BaseTabBar {
    func setupTabBar() {
        backgroundColor = .clear
        shadowImage = UIImage()
        itemPositioning = .fill
        layer.borderColor = UIColor.clear.cgColor
        items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        }
    }

    func setupAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowImage = UIImage()
        tabBarAppearance.backgroundImage = UIImage()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.92
        paragraphStyle.alignment = .center

        let appearance = UITabBarItem.appearance()
        appearance.titleAttributes(
            [
                .font(.regular(11)),
                .color(.gray()),
                .paragraph(paragraphStyle)

            ],
            for: .normal
        )
        appearance.titleAttributes(
            [
                .font(.regular(11)),
                .color(.blue()),
                .paragraph(paragraphStyle)

            ],
            for: .selected
        )
    }

    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.1019607843, alpha: 1).withAlphaComponent(0.12).cgColor
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shapeLayer.shadowRadius = 16
        shapeLayer.borderColor = UIColor.clear.cgColor

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.addSublayer(shapeLayer)
        }

        self.shapeLayer = shapeLayer
    }

    func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 0, height: 0))

        return path.cgPath
    }
}
