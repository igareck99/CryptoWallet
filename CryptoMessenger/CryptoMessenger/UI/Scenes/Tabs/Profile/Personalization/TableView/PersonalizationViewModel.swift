import UIKit

// MARK: - PersonalizationViewModel

struct PersonalizationViewModel {

    // MARK: - Type

    typealias ItemType = PersonalizationItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = CGFloat(0)
        static let rowHeight = CGFloat(64)
        static let numberRows = 1
    }
}

// MARK: - PersonalizationViewModel (TableViewProviderViewModel)

extension PersonalizationViewModel: TableViewProviderViewModel {
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