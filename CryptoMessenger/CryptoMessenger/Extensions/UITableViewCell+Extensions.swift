import UIKit

// MARK: - UITableViewCell ()

extension UITableViewCell {

    // MARK: - Static Properties

    static var identifier: String { return String(describing: self.self) }

    class var nib: UINib { UINib(nibName: identifier, bundle: nil) }
}
