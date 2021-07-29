import UIKit

// MARK: - UICollectionViewCell ()

extension UICollectionViewCell {

    // MARK: - Static Properties

    static var identifier: String { return String(describing: self.self) }

    class var nib: UINib { UINib(nibName: identifier, bundle: nil) }
}
