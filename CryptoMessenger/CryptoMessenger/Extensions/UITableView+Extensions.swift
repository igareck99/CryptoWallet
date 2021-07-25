import UIKit

// MARK: - UITableView ()

extension UITableView {

    // MARK: - Internal Methods

    func register<T: UITableViewCell>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: cell.className)
    }

    func dequeue<T: UITableViewCell>(_ cell: T.Type) -> T {
        dequeueReusableCell(withIdentifier: cell.className) as! T
    }

    func dequeue<T: UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as! T
    }

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ headerFooter: T.Type) {
        register(headerFooter, forHeaderFooterViewReuseIdentifier: headerFooter.className)
    }

    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ headerFooter: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: headerFooter.className) as! T
    }
}
