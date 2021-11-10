import UIKit

// MARK: - SessionView

final class SessionView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var descriptionLabel = UILabel()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: SessionProviderViewModel = .init(sessionList) {
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
        addDescriptionLabel()
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

    private func addDescriptionLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        paragraphStyle.alignment = .left

        descriptionLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.sessionDescription(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 3
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.snp.topMargin).offset(16)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.separatorStyle = .none
            $0.allowsSelection = true
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalTo($1)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([SessionCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: SessionCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            selectedCell = indexPath.section
            didTap?()
        }
    }

}

var selectedCell = 0

var sessionList: [SessionItem] = [
    .init(device: .iphone, loginMethod: "Приложение Aura", time: "сегодня в 14:11", place: "Москва, Россия"),
    .init(device: .iphone, loginMethod: "Приложение Aura", time: "вчера в 10:09", place: "Москва, Россия"),
    .init(device: .android, loginMethod: "Приложение Aura", time: "14 ноября в 22:39", place: "Москва, Россия"),
    .init(device: .iphone, loginMethod: "Приложение Aura", time: "13 ноября в 07:45", place: "Москва, Россия")
]
