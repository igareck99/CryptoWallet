import UIKit

// MARK: - PersonalizationView

final class PersonalizationView: UIView {

    // MARK: - Internal Properties

    var didTapLanguage: VoidBlock?
    var didTapTheme: VoidBlock?
    var didTapTypography: VoidBlock?
    var didTapProfileBackground: VoidBlock?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: PersonalizationViewModel = .init(personalizationList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        setupTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(PersonalizationCell.self, forCellReuseIdentifier: PersonalizationCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(16)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([PersonalizationCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: PersonalizationCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            if indexPath.section == 0 {
                didTapLanguage?()
            }
            if indexPath.section == 1 {
                didTapTheme?()
                tableView.reloadData()
            }
            if indexPath.section == 2 {
                didTapProfileBackground?()
            }
            if indexPath.section == 3 {
                didTapTypography?()
            }
        }
    }
}

var personalizationList: [PersonalizationItem] = [
    .init(title: "Язык приложения", currentState: "Русский"),
    .init(title: "Тема", currentState: "По умолчанию"),
    .init(title: "Фон профиля", currentState: "По умолчанию"),
    .init(title: "Типографика", currentState: "Управление...ом шрифта")
]
