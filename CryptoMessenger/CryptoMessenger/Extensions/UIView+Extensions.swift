import UIKit

// MARK: - UIView ()

extension UIView {

    // MARK: - Actions

    @objc func dismissKeyboard() {
        endEditing(true)
    }

    // MARK: - Internal Methods

    final func addDismissOnTap(_ cancelsTouchesInView: Bool = false) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = cancelsTouchesInView
        addGestureRecognizer(tapGesture)
    }

    final func clipCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    final func clipTopCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = radius
    }

    final func clipBottomCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = radius
    }

    final func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = false
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    final func animateScaleEffect(_ completion: (() -> Void)? = nil) {
        layer.removeAllAnimations()

        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut]) {
            self.transform = .init(scaleX: 1.03, y: 1.03)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
                self.transform = .identity
            }
            completion?()
        }
    }

    final func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

    final func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1) {
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = true
        clipsToBounds = false
    }

    final func addSubViews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func shake(duration: CFTimeInterval) {
        let shakeValues = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = shakeValues

        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = shakeValues.map { (Int(Double.pi) * $0) / 180 }

        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        layer.add(shakeGroup, forKey: "shakeIt")
    }
}
