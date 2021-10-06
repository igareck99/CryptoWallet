import UIKit

// MARK: - QuestionView

final class QuestionView: UIView {

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: QuestionViewModel = .init(questionList) {
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

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(16)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([QuestionCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: QuestionCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
    }

}

var questionList: [QuestionItem] = [
    QuestionItem(text: R.string.localizable.answersQuestionUpload(), type: 0),
    QuestionItem(text: R.string.localizable.answersQuestionApprove(), type: 0),
    QuestionItem(text: R.string.localizable.answersQuestionStatus(), type: 0),
    QuestionItem(text: R.string.localizable.answersQuestionChats(), type: 0),
    QuestionItem(text: R.string.localizable.answersQuestionContacts(), type: 0),
    QuestionItem(text: R.string.localizable.answersQuestionAudioVideo(), type: 0)
]
