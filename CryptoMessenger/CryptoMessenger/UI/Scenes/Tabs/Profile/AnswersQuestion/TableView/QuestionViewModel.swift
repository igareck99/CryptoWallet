import UIKit

// MARK: - QuestionViewModel

struct QuestionViewModel {

    // MARK: - Type

    typealias ItemType = QuestionItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = Float(0)
        static let rowHeight = Float(64)
        static let numberRows = 1
    }
}

// MARK: - QuestionViewModel (TableViewProviderViewModel)

extension QuestionViewModel: TableViewProviderViewModel {
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
