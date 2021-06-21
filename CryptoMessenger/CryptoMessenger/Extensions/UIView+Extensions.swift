import UIKit

// MARK: UIView ()

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

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .autoreverse]) {
            self.transform = .init(scaleX: 1.06, y: 1.06)
        } completion: { _ in
            self.transform = .identity
            completion?()
        }
    }
}
