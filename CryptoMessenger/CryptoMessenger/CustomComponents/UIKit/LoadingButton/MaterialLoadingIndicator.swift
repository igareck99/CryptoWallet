import UIKit

class MaterialLoadingIndicator: UIView, IndicatorProtocol {
    var radius = CGFloat(18)
    var isAnimating = false
    var color: Palette = .blue() {
        didSet {
            drawableLayer.strokeColor = color.uiColor.cgColor
        }
    }
    var lineWidth: CGFloat = 2.5 {
        didSet {
            drawableLayer.lineWidth = lineWidth
            self.updatePath()
        }
    }

    private let drawableLayer = CAShapeLayer()

    override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }

    convenience init(radius: CGFloat = 18, color: Palette = .blue()) {
        self.init()
        self.radius = radius
        self.color = color
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }

    private func setup() {
        isHidden = true
        layer.addSublayer(drawableLayer)
        drawableLayer.strokeColor = color.uiColor.cgColor
        drawableLayer.lineWidth = lineWidth
        drawableLayer.fillColor = UIColor.clear.cgColor
        drawableLayer.lineJoin = CAShapeLayerLineJoin.round
        drawableLayer.strokeStart = 0.99
        drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }

    private func updateFrame() {
        drawableLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius: CGFloat = radius - lineWidth

        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: true
        ).cgPath
    }

    func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        isHidden = false
        setupAnimation(in: drawableLayer, size: .zero)
    }

    func stopAnimating() {
        drawableLayer.removeAllAnimations()
        isAnimating = false
        isHidden = true
    }

    func setupAnimation(in layer: CALayer, size: CGSize) {
        layer.removeAllAnimations()

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.duration = 4
        rotation.toValue = 2 * Double.pi
        rotation.repeatCount = Float.infinity
        rotation.isRemovedOnCompletion = false

        let startHead = CABasicAnimation(keyPath: "strokeStart")
        startHead.beginTime = 0.1
        startHead.fromValue = 0
        startHead.toValue = 0.25
        startHead.duration = 1
        startHead.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let startTail = CABasicAnimation(keyPath: "strokeEnd")
        startTail.beginTime = 0.1
        startTail.fromValue = 0
        startTail.toValue = 1
        startTail.duration = 1
        startTail.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let endHead = CABasicAnimation(keyPath: "strokeStart")
        endHead.beginTime = 1
        endHead.fromValue = 0.25
        endHead.toValue = 0.99
        endHead.duration = 0.5
        endHead.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let endTail = CABasicAnimation(keyPath: "strokeEnd")
        endTail.beginTime = 1
        endTail.fromValue = 1
        endTail.toValue = 1
        endTail.duration = 0.5
        endTail.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let strokeGroup = CAAnimationGroup()
        strokeGroup.duration = 1.5
        strokeGroup.animations = [startHead, startTail, endHead, endTail]
        strokeGroup.repeatCount = .infinity
        strokeGroup.isRemovedOnCompletion = false

        layer.add(rotation, forKey: "rotation")
        layer.add(strokeGroup, forKey: "stroke")
    }
}
