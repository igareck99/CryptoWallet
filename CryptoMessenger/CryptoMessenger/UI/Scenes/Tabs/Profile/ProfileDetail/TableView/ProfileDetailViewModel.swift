import UIKit

// MARK: - ProfileDetailViewModel

struct ProfileDetailViewModel {

    // MARK: - Type

    typealias ItemType = ProfileDetailItem

    // MARK: - Internal Properties

    let item: ItemType

    // MARK: - Lifecycle

    init(_ item: ItemType) {
        self.item = item
    }

    // MARK: - SectionType

    enum SectionType: CaseIterable {

        // MARK: - Types

        case status, description, name, countryCode, phoneNumber
        case socialNetwork, exit, removeAccount

        var title: String? {
            switch self {
            case .status:
                return "Статус"
            case .description:
                return "Описание"
            case .name:
                return "Имя пользователя"
            case .countryCode:
                return "Номер телефона"
            default:
                return nil
            }
        }
    }

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let defaultRowHeight = CGFloat(64)
        static let numberRows = 1
    }
}

// MARK: - MenuListViewModel (TableViewProviderViewModel)

extension ProfileDetailViewModel: TableViewProviderViewModel {
    func heightForHeader(atIndex index: Int) -> CGFloat {
        let type = SectionType.allCases[index]
        switch type {
        case .status, .description, .name, .countryCode:
            return 54
        case .phoneNumber:
            return 12
        case .socialNetwork:
            return 24
        case .exit:
            return 32
        case .removeAccount:
            return 0
        }
    }

    func headerView(atIndex index: Int) -> UIView? {
        let type = SectionType.allCases[index]
        let height = heightForHeader(atIndex: index)
        let view = UIView()
        view.frame = CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width - 32, height: CGFloat(height))
        view.background(.white())

        switch type {
        case .status, .description, .name, .countryCode:
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: UIScreen.main.bounds.width - 32, height: 22))
            label.textAlignment = .left
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = 1.54
            paragraph.alignment = .left
            label.titleAttributes(
                text: type.title?.uppercased() ?? "",
                [
                    .color(.darkGray()),
                    .font(.semibold(12)),
                    .paragraph(paragraph)
                ]
            )
            view.addSubview(label)
            return view
        case .phoneNumber:
            return view
        case .socialNetwork:
            return view
        case .exit:
            return view
        case .removeAccount:
            return nil
        }
    }

    func numberOfTableSections() -> Int {
        SectionType.allCases.count
    }

    func numberOfTableRowsInSection(_ section: Int) -> Int {
        Constants.numberRows
    }

    func heightForRow(indexPath: IndexPath) -> CGFloat {
        let type = SectionType.allCases[indexPath.section]
        switch type {
        case .status, .description, .name:
            return UITableView.automaticDimension
        case .countryCode, .phoneNumber:
            return 44
        case .socialNetwork, .exit, .removeAccount:
            return Constants.defaultRowHeight
        }
    }
}
