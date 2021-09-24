import UIKit

// MARK: - AdditionalMenuView

final class MenuFriendView: UIView {

    // MARK: - Internal Properties

    var didTapDelete: VoidBlock?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
    private lazy var balanceLabel = UILabel()
    private lazy var firstLineView = UIView()
    private lazy var secondLineView = UIView()
    private lazy var indicatorView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: FriendMenuListViewModel = .init(friendMenuList) {
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
        addindicatorView()
        setupTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addindicatorView() {
        indicatorView.snap(parent: self) {
            $0.background(.gray(0.4))
            $0.clipCorners(radius: 2)
        } layout: {
            $0.top.equalTo($1).offset(6)
            $0.centerX.equalTo($1)
            $0.width.equalTo(31)
            $0.height.equalTo(4)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(MenuFriendCell.self, forCellReuseIdentifier: MenuCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(16)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([MenuFriendCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: MenuFriendCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
    }
}

private var friendMenuList: [MenuFriendItem] = [
    .init(text: R.string.localizable.friendProfileNotifications(), image: R.image.friendProfile.notifications()),
    .init(text: R.string.localizable.friendProfileShareContact(), image: R.image.friendProfile.shareContact()),
    .init(text: R.string.localizable.friendProfileAddContact(), image: R.image.friendProfile.addContact()),
    .init(text: R.string.localizable.friendProfileMedia(), image: R.image.friendProfile.media()),
    .init(text: R.string.localizable.friendProfileNotes(), image: R.image.friendProfile.notes()),
    .init(text: R.string.localizable.friendProfileComplain(), image: R.image.friendProfile.complain()),
    .init(text: R.string.localizable.friendProfileBlock(), image: R.image.friendProfile.block())
]
