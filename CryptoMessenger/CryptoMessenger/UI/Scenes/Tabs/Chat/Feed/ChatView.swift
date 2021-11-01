import UIKit

// MARK: - ChatView

final class ChatView: UIView {

    // MARK: - Internal Properties

    var didTapNextScene: ((Message) -> Void)?

    // MARK: - Private Properties

    private lazy var footerView = UIView()
    private lazy var inviteButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var filteredViewModel: ChatViewModel = .init([])
    private var tableModel: ChatViewModel = .init(sortedMessages) {
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
        addMessagesTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func updateSearchResults(_ text: String) {
        if text.isEmpty {
            filteredViewModel = tableModel
        } else {
            filteredViewModel = .init(tableModel.items.filter { $0.name.lowercased().contains(text.lowercased()) })
        }
        tableProvider?.setViewModel(with: filteredViewModel)
        tableProvider?.reloadData()
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
            $0.separatorStyle = .none
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
            let item = filteredViewModel.items.isEmpty
                ? tableModel.items[indexPath.section]
                : filteredViewModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            let item = filteredViewModel.items.isEmpty
                ? tableModel.items[indexPath.section]
                : filteredViewModel.items[indexPath.section]

            didTapNextScene?(item)
        }
    }
}

private var sortedMessages = messages.filter({ $0.isPinned }) + messages.filter({ !$0.isPinned })
private var messages: [Message] = [
    .init(
        type: .text("Не совсем понял прикола"),
        status: .offline,
        name: "Данил Даньшиншиншиншиншиншиншиншиншиншин",
        avatar: R.image.chat.mockAvatar1(),
        date: "21:30",
        unreadCount: 1
    ),
    .init(
        type: .text("Короче, ты мне Ауру, и ??? :)\nИ я твоя!!!"),
        status: .offline,
        name: "Марина Антоненко",
        avatar: R.image.chat.mockAvatar2(),
        date: "11:08",
        unreadCount: 2
    ),
    .init(
        type: .text("Привет, трудяга!:)"),
        status: .online,
        name: "Артем Квач",
        avatar: R.image.chat.mockAvatar3(),
        date: "03:40",
        unreadCount: 0,
        isPinned: true
    ),
    .init(
        type: .text("Подними кэш на ставках!"),
        status: .online,
        name: "Фон Бет",
        avatar: R.image.chat.mockAvatar4(),
        date: "22:00",
        unreadCount: 666
    )
]
