import UIKit

// MARK: - AdditionalMenuView

final class AdditionalMenuView: UIView {

    // MARK: - Internal Properties

    var didTapDelete: VoidBlock?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
    private lazy var balanceLabel = UILabel()
    private lazy var firstLineView = UIView()
    private lazy var secondLineView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var indicatorView = UIView()
    private var tableProvider: TableViewProvider?
    private var tableModel: MenuListViewModel = .init(menuList) {
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
        setupAuraImage()
        setupBalanceLabel()
        addLineView()
        setupTableView()
        setupTableProvider()
        addSecondLineView()
        print(tableModel.items)
        print(tableModel.numberOfTableSections())
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

    private func setupAuraImage() {
        auraImage.snap(parent: self) {
            $0.image = R.image.pinCode.aura()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.width.height.equalTo(24)
            $0.top.equalTo(self.snp_topMargin).offset(18)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func setupBalanceLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        balanceLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "0.50 AUR",
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(16)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(19.7)
            $0.leading.equalTo($1).offset(48)
        }
    }

    private func addLineView() {
        firstLineView.snap(parent: self) {
            $0.background(.gray(0.4))
        } layout: {
            $0.top.equalTo($1).offset(58)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(80)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([MenuCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: MenuCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
    }

    private func addSecondLineView() {
        secondLineView.snap(parent: self) {
            $0.background(.gray(0.4))
        } layout: {
            $0.top.equalTo($1).offset(534)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }
}

private  var menuList: [MenuItem] = [
    .init(text: R.string.localizable.additionalMenuProfile(),
          image: R.image.additionalMenu.profile(), isNotifications: false),
        .init(text: R.string.localizable.additionalMenuPersonalization(),
              image: R.image.additionalMenu.personaliztion(), isNotifications: false),
        .init(text: R.string.localizable.additionalMenuSecurity(),
              image: R.image.additionalMenu.security(), isNotifications: false),
        .init(text: R.string.localizable.additionalMenuWallet(),
              image: R.image.additionalMenu.wallet(), isNotifications: false),
        .init(text: R.string.localizable.additionalMenuNotification(),
              image: R.image.additionalMenu.notifications(), isNotifications: false)
]
