import UIKit

// MARK: - MenuListViewModel

struct MenuListViewModel {

    // MARK: - Type

    typealias ItemType = MenuItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = CGFloat(32)
        static let rowHeight = CGFloat(64)
        static let numberRows = 1
    }
}

// MARK: - MenuListViewModel (TableViewProviderViewModel)

extension MenuListViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> CGFloat {
        index == 7 ? Constants.heightForHeader : 0
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