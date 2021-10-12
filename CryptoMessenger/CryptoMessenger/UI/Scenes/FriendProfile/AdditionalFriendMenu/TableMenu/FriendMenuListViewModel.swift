import UIKit

// MARK: - MenuListViewModel

struct FriendMenuListViewModel {

    // MARK: - Type

    typealias ItemType = MenuFriendItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {
        static let heightForHeader = CGFloat(0)
        static let rowHeight = CGFloat(64)
        static let numberRows = 1
    }
}

// MARK: - MenuListViewModel (TableViewProviderViewModel)

extension FriendMenuListViewModel: TableViewProviderViewModel {
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
