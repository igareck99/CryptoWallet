import UIKit

// MARK: - UIButton ()

extension UIButton {

    // MARK: - Internal Methods

    func setBackgroundColor(color: Palette, forState: UIControl.State) {
        let minimumSize = CGSize(width: 1, height: 1)

        UIGraphicsBeginImageContext(minimumSize)

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }

        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        clipsToBounds = true
        setBackgroundImage(colorImage, for: forState)
    }
}
