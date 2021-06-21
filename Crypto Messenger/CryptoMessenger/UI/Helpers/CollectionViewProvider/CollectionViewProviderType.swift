import UIKit

// MARK: CollectionViewProviderType

protocol CollectionViewProviderType {
    var onConfigureCell: ((IndexPath) -> UICollectionViewCell)? { get set }
    var onSelectCell: ((IndexPath) -> Void)? { get set }
    var onConfigureCellSize: ((IndexPath) -> CGSize)? { get set }

    func registerCells(_ cells: [UICollectionViewCell.Type])
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell
    func reloadData()
}
