import UIKit

// MARK: - ProfileNetworkDetailView

final class ProfileNetworkDetailView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Methods

    private lazy var mainLabel = UILabel()
    private lazy var messageLabel = UILabel()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: NetworkDetailViewModel = .init(tableNetworkList) {
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
        // self.tableView.dragDelegate = self
        background(.white())
        addMainLabel()
        addMessageLabel()
        setupTableView()
        setupTableProvider()
        debugPrint(tableNetworkList)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addMainLabel() {
        mainLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileNetworkDetailMain(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .center)),
                    .font(.bold(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addMessageLabel() {
        messageLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileNetworkDetailMessage(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 2
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.mainLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(NetworkDetailCell.self, forCellReuseIdentifier: NetworkDetailCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = false
            $0.setEditing(true, animated: true)
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo(self.messageLabel.snp.bottom).offset(8)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([NetworkDetailCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: NetworkDetailCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            cell.background(.paleBlue())
            return cell
        }
        tableProvider?.onViewForHeaderInSection = { [unowned self] section in
            let height = tableModel.heightForHeader(atIndex: section)
            guard height > 0 else { return nil }
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(height)))
            header.background(.white())
            let label = UILabel()
            label.snap(parent: header) {
                $0.titleAttributes(
                    text: R.string.localizable.profileNetworkDetailNotShowMessage(),
                    [
                        .paragraph(.init(lineHeightMultiple: 1.22, alignment: .center)),
                        .font(.bold(12)),
                        .color(.gray())
                    ]
                )
                $0.lineBreakMode = .byWordWrapping
                $0.numberOfLines = 0
                $0.textAlignment = .left
            } layout: {
                $0.height.equalTo(22)
                $0.top.equalTo($1).offset(24)
                $0.leading.equalTo($1).offset(16)
            }
            return header
        }
    }
}

// MARK: - ProfileNetworkDetailView ()

extension ProfileNetworkDetailView {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row != tableNetworkList.count - 1 else { return }
        tableNetworkList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        tableModel = .init(tableNetworkList)
        tableView.reloadData()
    }
}

var tableNetworkList: [NetworkDetailItem] = [
    NetworkDetailItem(text: "twitter.com/arestov_lv",
                      type: 0),
    NetworkDetailItem(text: "facebook.com/arestov_design",
                      type: 0),
    NetworkDetailItem(text: "instagram.com/arestov_design",
                      type: 0),
    NetworkDetailItem(text: "dribbble.com/arestov.design",
                      type: 0),
    NetworkDetailItem(text: R.string.localizable.profileNetworkDetailNotShowLink(),
                      type: 1)

].sorted(by: { $0.type < $1.type })
