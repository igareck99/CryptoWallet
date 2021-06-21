import UIKit

// MARK: TableViewProviderType

protocol TableViewProviderType {
    var onConfigureCell: ((IndexPath) -> UITableViewCell)? { get set }
    var onSelectCell: ((IndexPath) -> Void)? { get set }
    var onSlideCell: ((IndexPath) -> UISwipeActionsConfiguration?)? { get set }

    func registerCells(_ cells: [UITableViewCell.Type])
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell
    func reloadData()
}
