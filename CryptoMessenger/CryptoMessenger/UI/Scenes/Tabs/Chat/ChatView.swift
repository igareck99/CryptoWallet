import UIKit

// MARK: - ChatView

final class ChatView: UIView {

    // MARK: - Private Properties

    private lazy var footerView = UIView()
    private lazy var inviteButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    private var tableProvider: TableViewProvider?
    private var tableModel: ChatViewModel = .init(messages) {
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
        addInviteButton()
        addMessagesTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addInviteButton() {
        inviteButton.snap(parent: footerView) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.09
            paragraphStyle.alignment = .center

            let title = "Пригласить друзей"
            $0.titleAttributes(
                text: title,
                [
                    .color(.white()),
                    .font(.bold(15)),
                    .paragraph(paragraphStyle)
                ]
            )
            $0.background(.blue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo($1).offset(50)
            $0.leading.equalTo($1).offset(67)
            $0.trailing.equalTo($1).offset(-67)
            $0.height.equalTo(44)
        }
    }

    private func addMessagesTableView() {
        footerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 120)
        footerView.background(.white())

        tableView.snap(parent: self) {
            $0.separatorStyle = .singleLine
            $0.separatorInset = .init(top: 0, left: 88, bottom: 0, right: 16)
            $0.tableFooterView = self.footerView
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([ChatTableViewCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: ChatTableViewCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
    }
}

private var messages: [Message] = [
    .init(
        name: "AURA Chat Bot",
        icon: R.image.chat.botLogo(),
        message: "Привет, давай знакомиться :)",
        date: "21:30",
        unreadMessagesCount: 2
    )
]
