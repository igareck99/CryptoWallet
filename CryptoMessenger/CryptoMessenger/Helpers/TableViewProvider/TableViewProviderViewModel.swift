import UIKit

// MARK: - TableViewProviderViewModel

protocol TableViewProviderViewModel {
    func numberOfTableSections() -> Int
    func numberOfTableRowsInSection(_ section: Int) -> Int
    func heightForRow(indexPath: IndexPath) -> CGFloat
    func heightForHeader(atIndex index: Int) -> CGFloat
}
