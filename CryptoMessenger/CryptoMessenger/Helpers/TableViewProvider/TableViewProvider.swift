import UIKit

// MARK: - TableViewProvider

final class TableViewProvider: NSObject, TableViewProviderType {

    // MARK: - Internal Properties

    var onConfigureCell: ((IndexPath) -> UITableViewCell)?
    var onViewForHeaderInSection: ((Int) -> UIView?)?
    var onSelectCell: ((IndexPath) -> Void)?
    var onSlideCell: ((IndexPath) -> UISwipeActionsConfiguration?)?
    var onMoveCell : ((IndexPath, IndexPath) -> Void)?

    // MARK: - Private Properties

    private let tableView: UITableView
    private var viewModel: TableViewProviderViewModel

    // MARK: - Lifecycle

    init(for tableView: UITableView, with viewModel: TableViewProviderViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel

        super.init()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    // MARK: - Internal Methods

    func setViewModel(with viewModel: TableViewProviderViewModel) {
        self.viewModel = viewModel
    }

    func registerCells(_ cells: [UITableViewCell.Type]) {
        cells.forEach { registerCell($0) }
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    func reloadData() {
        tableView.reloadData()
    }

    // MARK: - Private Methods

    private func registerCell<T>(_ type: T.Type) where T: UITableViewCell {
        if let nibLoadableType = type as? NibLoadableView.Type {
            let nib = UINib(nibName: nibLoadableType.nibName, bundle: Bundle(for: type.self))
            tableView.register(nib, forCellReuseIdentifier: String(describing: type))
        } else {
            tableView.register(type.self, forCellReuseIdentifier: String(describing: type))
        }
    }
}

// MARK: - TableViewProvider (UITableViewDataSource)

extension TableViewProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfTableSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTableRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let onConfigureCell = onConfigureCell else {
            fatalError("Need to init onConfigureCell")
        }

        return onConfigureCell(indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return onSlideCell?(indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return onViewForHeaderInSection?(section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.heightForHeader(atIndex: section))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRow(atIndex: indexPath.row))
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == tableNetworkList.count - 1 {
            print("return")
            return
        } else {
            tableNetworkList.swapAt(sourceIndexPath.row, destinationIndexPath.row)

            // tableView.reloadData()
        }
    }
}

// MARK: - TableViewProvider (UITableViewDelegate)

extension TableViewProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        onSelectCell?(indexPath)
    }
}
