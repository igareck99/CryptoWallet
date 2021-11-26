import UIKit

// MARK: - QuestionViewModel

struct QuestionViewModel {

    // MARK: - Type

    typealias ItemType = QuestionItem

    // MARK: - Internal Properties

    var items: [ItemType]

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

// MARK: - QuestionViewModel (TableViewProviderViewModel)

extension QuestionViewModel: TableViewProviderViewModel {
    func numberOfTableRowsInSection(_ section: Int) -> Int {
        Constants.numberRows
    }

    func heightForRow(indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }

    func heightForHeader(atIndex index: Int) -> CGFloat {
        Constants.heightForHeader
    }

    func numberOfTableSections() -> Int {
        items.count
    }
}
