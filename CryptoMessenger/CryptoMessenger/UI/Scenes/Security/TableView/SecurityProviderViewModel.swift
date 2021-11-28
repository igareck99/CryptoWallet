import UIKit

// MARK: - SecurityProviderViewModel

struct SecurityProviderViewModel {

    // MARK: - Type

    typealias ItemType = SecurityItem

    // MARK: - Internal Properties

    let items: [ItemType]
    var userFlows = UserFlowsStorageService()

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - SectionType

    enum SectionType: CaseIterable {

        // MARK: - Types

        case security
        case privacy
        case blackListUser
        case additionalSecurity
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let securityHeaderHeight = CGFloat(46)
        static let privacyHeaderHeight = CGFloat(62)
        static let defaultRowHeight = CGFloat(64)
        static let numberRows = 1
        static let heightForHeader = CGFloat(0)
    }
}

// MARK: - SecurityProviderViewModel (TableViewProviderViewModel)

extension SecurityProviderViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> CGFloat {
        if userFlows.isPinCodeOn == false {
            if index == 0 {
                return Constants.securityHeaderHeight
            }
            if index == 1 {
                return Constants.privacyHeaderHeight
            }
            return Constants.heightForHeader
        } else {
            if index == 0 {
                return Constants.securityHeaderHeight
            }
            if index == 3 {
                return Constants.privacyHeaderHeight
            }
            return Constants.heightForHeader
        }
    }

    func numberOfTableSections() -> Int {
        return items.count
    }

    func numberOfTableRowsInSection(_ section: Int) -> Int {
        Constants.numberRows
    }

    func heightForRow(indexPath: IndexPath) -> CGFloat {
        return Constants.defaultRowHeight
    }
}
