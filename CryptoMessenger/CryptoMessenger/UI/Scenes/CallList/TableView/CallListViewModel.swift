import Foundation

// MARK: - CallListViewModel

struct CallListViewModel {

    // MARK: - Type

    typealias ItemType = CallItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {
        static let heightForHeader = Float(0)
        static let rowHeight = Float(70)
        static let numberRows = 1
    }
}

// MARK: - CallListViewModel (TableViewProviderViewModel)

extension CallListViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> Float {
        Constants.heightForHeader
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