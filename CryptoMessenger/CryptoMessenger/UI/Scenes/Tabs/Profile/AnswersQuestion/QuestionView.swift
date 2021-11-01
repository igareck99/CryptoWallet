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
            cell.background(.white())
            if item.type == 1 || item.type == 2 {
                cell.background(.lightBlue())
            }
            cell.configure(item)
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            if tableModel.items[indexPath.section].type == 0 {
                questionList[indexPath.section].type = 1
                if tableModel.items[indexPath.section].array.isEmpty != true {
                    for x in tableModel.items[indexPath.section].array {
                        var index = 1
                        questionList.insert(x, at: indexPath.section + index)
                        index += 1
                    }
                }
                tableModel = .init(questionList)
                setupTableProvider()
            } else if tableModel.items[indexPath.section].type == 1 {
                questionList[indexPath.section].type = 0
                questionList = questionList.filter { $0.type != 2 }
                tableModel = .init(questionList)
                setupTableProvider()
            }
        }
    }

}

var questionList: [QuestionItem] = [
    QuestionItem(text: R.string.localizable.answersQuestionUpload(), type: 0, array: []),
    QuestionItem(text: R.string.localizable.answersQuestionApprove(), type: 0, array: []),
    QuestionItem(text: R.string.localizable.answersQuestionStatus(), type: 0, array: [
                    QuestionItem(text: R.string.localizable.answersQuestionStatusFirst(),
                                 type: 2, array: []),
                    QuestionItem(text: R.string.localizable.answersQuestionStatusSecond(),
                                 type: 2, array: [] )]),
    QuestionItem(text: R.string.localizable.answersQuestionChats(), type: 0, array: []),
    QuestionItem(text: R.string.localizable.answersQuestionContacts(), type: 0, array: []),
    QuestionItem(text: R.string.localizable.answersQuestionAudioVideo(), type: 0, array: [])
]
