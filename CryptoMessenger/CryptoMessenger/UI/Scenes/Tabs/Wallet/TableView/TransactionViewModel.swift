import UIKit

// MARK: - TransactionViewModel

struct TransactionViewModel {

    // MARK: - Type

    typealias ItemType = Transaction

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {
        static let heightForHeader = CGFloat(0)
        static let rowHeight = CGFloat(72)
        static let numberRows = 1
    }
}

// MARK: - TransactionViewModel (TableViewProviderViewModel)

extension TransactionViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> CGFloat {
        Constants.heightForHeader
    }

    func numberOfTableSections() -> Int {
        items.count
    }

    func numberOfTableRowsInSection(_ section: Int) -> Int {
        Constants.numberRows
    }

    func heightForRow(indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
}
