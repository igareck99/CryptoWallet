import UIKit

// MARK: - ProfileDetailViewModel

struct NetworkDetailViewModel {

    // MARK: - Type

    typealias ItemType = NetworkDetailItem

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let heightForHeader = CGFloat(54)
        static let rowHeight = CGFloat(44)
        static let numberRows = 1
    }
}

// MARK: - NetworkDetailViewModel (TableViewProviderViewModel)

extension NetworkDetailViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> CGFloat {
        let separator_index = tableNetworkList.firstIndex(where: { $0.type == 1 })
        return index == separator_index ? Constants.heightForHeader : 0
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
