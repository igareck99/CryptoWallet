import UIKit

// MARK: - AdditionalMenuView

final class AdditionalMenuView: UIView {

    // MARK: - Internal Properties

    var didProfileDetailTap: VoidBlock?
    var didPersonalizationTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
    private lazy var balanceLabel = UILabel()
    private lazy var firstLineView = UIView()
    private lazy var secondLineView = UIView()
    private lazy var indicatorView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
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
        addIndicatorView()
        setupAuraImage()
        setupBalanceLabel()
        addLineView()
        setupTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addIndicatorView() {
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
            $0.top.equalTo($1).offset(18)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func setupBalanceLabel() {
        balanceLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "0.50 AUR",
                [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .center)),
                    .font(.regular(16)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo($1).offset(19.7)
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
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(70)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([MenuCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: MenuCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            cell.didTap = {
                if indexPath.section == 0 {
                    didProfileDetailTap?()
                }
                if indexPath.section == 1 {
                    didPersonalizationTap?()
                }
            }
            return cell
        }
        tableProvider?.onViewForHeaderInSection = { [unowned self] section in
            let height = tableModel.heightForHeader(atIndex: section)
            guard height > 0 else { return nil }
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(height)))
            let line = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            line.background(.gray(0.4))
            header.addSubview(line)
            line.center = header.center
            return header
        }
    }
}

private var menuList: [MenuItem] = [
    .init(text: R.string.localizable.additionalMenuProfile(),
          image: R.image.additionalMenu.profile(), notifications: 0),
    .init(text: R.string.localizable.additionalMenuPersonalization(),
          image: R.image.additionalMenu.personaliztion(), notifications: 0),
    .init(text: R.string.localizable.additionalMenuSecurity(),
          image: R.image.additionalMenu.security(), notifications: 0),
    .init(text: R.string.localizable.additionalMenuWallet(),
          image: R.image.additionalMenu.wallet(), notifications: 0),
    .init(text: R.string.localizable.additionalMenuNotification(),
          image: R.image.additionalMenu.notifications(), notifications: 1),
    .init(text: R.string.localizable.additionalMenuChats(), image: R.image.additionalMenu.chat(),
          notifications: 0),
    .init(text: R.string.localizable.additionalMenuData(), image: R.image.additionalMenu.dataStorage(),
          notifications: 0),
    .init(text: R.string.localizable.additionalMenuQuestions(),
          image: R.image.additionalMenu.answers(), notifications: 0),
    .init(text: R.string.localizable.additionalMenuAbout(),
          image: R.image.additionalMenu.about(), notifications: 0)
]
