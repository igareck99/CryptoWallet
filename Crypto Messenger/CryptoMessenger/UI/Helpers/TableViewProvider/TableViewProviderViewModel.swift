import UIKit

// MARK: TableViewProviderViewModel

protocol TableViewProviderViewModel {
    func numberOfTableSections() -> Int
    func numberOfTableRowsInSection(_ section: Int) -> Int
    func heightForRow(atIndex index: Int) -> Float
    func heightForHeader(atIndex index: Int) -> Float
}
