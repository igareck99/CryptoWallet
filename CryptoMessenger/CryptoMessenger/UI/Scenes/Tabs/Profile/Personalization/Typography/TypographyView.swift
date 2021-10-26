import UIKit

// MARK: - TypographyView

final class TypographyView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: TypographyViewModel = .init(typographyList) {
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

    func publicMethod() {

    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(TypographyCell.self, forCellReuseIdentifier: TypographyCell.identifier)
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
        tableProvider?.registerCells([TypographyCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: TypographyCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
    }
}

private var typographyList: [TypographyItem] = [
    .init(name: "Мелкий", size: "80%", type: false),
    .init(name: "Средний", size: "Как в системе (Русский)", type: true),
    .init(name: "Большой", size: "120%", type: false)
]
