import UIKit

// MARK: - ChatViewModel

struct ChatViewModel {

    // MARK: - Type

    typealias ItemType = Message

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {
        static let heightForHeader = CGFloat(0)
        static let rowHeight = CGFloat(84)
        static let numberRows = 1
    }
}

// MARK: - ChatViewModel (TableViewProviderViewModel)

extension ChatViewModel: TableViewProviderViewModel {
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
