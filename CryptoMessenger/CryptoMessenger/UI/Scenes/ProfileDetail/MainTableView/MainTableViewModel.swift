import UIKit

// MARK: - MainTableViewModel

struct MainTableViewModel {

    // MARK: - Type

    typealias ItemType = MainTableItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = Float(377)
        static let rowHeight = Float(850)
        static let numberRows = 1
    }
}

// MARK: - MainTableViewModel (TableViewProviderViewModel)

extension MainTableViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> Float {
        index == 0 ? Constants.heightForHeader : 0
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
