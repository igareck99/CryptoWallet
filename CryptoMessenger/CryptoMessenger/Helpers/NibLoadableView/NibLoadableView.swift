import UIKit

// MARK: NibLoadableView

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIViewController {
    static var nibName: String {
        return String(describing: self)
    }
}
