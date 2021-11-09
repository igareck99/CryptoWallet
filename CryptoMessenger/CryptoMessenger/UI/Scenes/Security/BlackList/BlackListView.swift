import UIKit

// MARK: - BlackListView

final class BlackListView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?
    var didUserTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var filteredViewModel: BlackListViewModel = .init([])
    private var tableModel: BlackListViewModel = .init(blockedPeople) {
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

    func unblockUser(index: Int) {
        blockedPeople.remove(at: index)
        filteredViewModel = .init(blockedPeople)
        tableProvider?.setViewModel(with: filteredViewModel)
        tableProvider?.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(TableBlackListCell.self, forCellReuseIdentifier: TableBlackListCell.identifier)
            $0.separatorInset.left = 68
            $0.separatorInset.right = 16
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(12)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([TableBlackListCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: TableBlackListCell = provider.dequeueReusableCell(for: indexPath)
            let item = filteredViewModel.items.isEmpty
                ? tableModel.items[indexPath.section]
                : filteredViewModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            selectedCellToBlock = indexPath.section
            didUserTap?()
        }
    }
}

var blockedPeople: [BlackListItem] = [
    .init(name: "Света Корнилова", status: "Привет, теперь я в Aura", image: R.image.callList.user2()),
    .init(name: "Давид Гретхом", status: "Готов к общению!", image: R.image.callList.user1()),
    .init(name: "Кирилл П.", status: "Работаю", image: R.image.callList.user4())
]
var selectedCellToBlock: Int = 0
