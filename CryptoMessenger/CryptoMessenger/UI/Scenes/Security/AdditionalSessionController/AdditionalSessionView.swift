import UIKit

// MARK: - AdditionalSessionView

final class AdditionalSessionView: UIView {

    // MARK: - Internal Properties

    var didCloseTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var closeButton = UIButton()
    private lazy var sessionLabel = UILabel()
    private lazy var lineView = UIView()
    private lazy var endSessionButton = UIButton()
    private lazy var indicatorView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: AdditionalSessionViewModel = .init(sessionInfo) {
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
        addCloseButton()
        setupSessionLabel()
        setupTableView()
        setupTableProvider()
        addLineView()
        addFinishSessionButton()
        addIndicatorView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Actions

    @objc private func closeAction() {
        didCloseTap?()
    }

    // MARK: - Private Methods

    private func addCloseButton() {
        closeButton.snap(parent: self) {
            $0.setImage(R.image.buyCellsMenu.close(), for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        } layout: {
            $0.top.leading.equalTo($1).offset(16)
            $0.width.height.equalTo(24)
        }
    }

    private func setupSessionLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.20
        paragraphStyle.alignment = .center
        sessionLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "Сессия " + loginDevice,
                [
                    .paragraph(paragraphStyle),
                    .font(.bold(15)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo($1).offset(18)
            $0.centerX.equalTo($1)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(AdditionalSessionCell.self, forCellReuseIdentifier: AdditionalSessionCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(69)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([AdditionalSessionCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: AdditionalSessionCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
    }

    private func addLineView() {
        lineView.snap(parent: self) {
            $0.background(.gray(0.4))
        } layout: {
            $0.top.equalTo($1).offset(343)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }

    private func addFinishSessionButton() {
        endSessionButton.snap(parent: self) {
            $0.background(.blue())
            $0.titleAttributes(
                text: R.string.localizable.sessionDetailFinish(),
                [
                    .font(.medium(15)),
                    .color(.white())
                ]
            )
            $0.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(44)
            $0.width.equalTo(185)
            $0.bottom.equalTo($1).offset(-41)
            $0.centerX.equalTo($1)
        }
    }

    private func addIndicatorView() {
        indicatorView.snap(parent: self) {
            $0.background(.darkBlack())
            $0.clipCorners(radius: 2)
        } layout: {
            $0.bottom.equalTo($1).offset(-8)
            $0.centerX.equalTo($1)
            $0.width.equalTo(134)
            $0.height.equalTo(5)
        }
    }
}

var loginDevice = "IPhone"

var sessionInfo: [AdditionalSessionItem] = [
    .init(title: R.string.localizable.sessionDetailPlace(), text: "Россия, Москва"),
    .init(title: R.string.localizable.sessionDetailTime(), text: "Сегодня в 14:59"),
    .init(title: R.string.localizable.sessionDetailApps(), text: "Android 4.1"),
    .init(title: R.string.localizable.sessionDetailIp(), text: "46.242.16.24")

]
