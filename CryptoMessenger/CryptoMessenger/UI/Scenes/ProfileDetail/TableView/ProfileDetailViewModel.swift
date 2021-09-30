import UIKit

// MARK: - ProfileDetailViewModel

struct ProfileDetailViewModel {

    // MARK: - Type

    typealias ItemType = ProfileDetailItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = Float(32)
        static let rowHeight = Float(64)
        static let numberRows = 1
    }
}

// MARK: - MenuListViewModel (TableViewProviderViewModel)

extension ProfileDetailViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> Float {
        index == 1 ? Constants.heightForHeader : 0
    }

    func numberOfTableSections() -> Int {
        items.count
    }

    func numberOfTableRowsInSection(_ section: Int) -> Int {
        Constants.numberRows
    }

    func heightForRow(atIndex index: Int) -> Float {
        Constants.rowHeight
    }
}
