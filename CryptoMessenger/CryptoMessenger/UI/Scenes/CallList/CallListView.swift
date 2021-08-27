import UIKit

// MARK: - CallListView

final class CallListView: UIView {

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var filteredViewModel: CallListViewModel = .init([])
    private var tableModel: CallListViewModel = .init(callList) {
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

    func removeCall(index: Int) {
        callList.remove(at: index)
        filteredViewModel = .init(callList)
        tableProvider?.setViewModel(with: filteredViewModel)
        tableProvider?.reloadData()
        print(tableModel.items)
    }

    func removeAllCalls() {
        callList.removeAll()
        filteredViewModel = .init(callList)
        tableProvider?.setViewModel(with: filteredViewModel)
        tableProvider?.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(CallCell.self, forCellReuseIdentifier: CallCell.identifier)
            $0.separatorInset.left = 68
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.top.equalTo($1)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([CallCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: CallCell = provider.dequeueReusableCell(for: indexPath)
            let item = filteredViewModel.items.isEmpty
                ? tableModel.items[indexPath.section]
                : filteredViewModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onSlideCell = { [unowned self] indexPath in
            let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _  in
                self.removeCall(index: indexPath.section)
            }
            action.backgroundColor = .red
            action.image = R.image.callList.deleteimage()
            return UISwipeActionsConfiguration(actions: [action])
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _  in
            self.removeCall(index: indexPath[1])
        }
        action.backgroundColor = .red
        action.image = R.image.callList.deleteimage()
        return UISwipeActionsConfiguration(actions: [action])
    }

}

private  var callList: [CallStruct] = [
    .init(name: "Martin Randolph", dateTime: "19 сен 18:59", image: R.image.callList.user1(),
          isIncall: false),
    .init(name: "Karen Castillo", dateTime: "07 сен 18:36", image: R.image.callList.user2(),
          isIncall: true),
    .init(name: "Kieron Dotson", dateTime: "04 сен 18:11", image: R.image.callList.user3(),
          isIncall: true),
    .init(name: "Jamie Franco", dateTime: "03 июн 06:27", image: R.image.callList.user4(),
          isIncall: true)
]
