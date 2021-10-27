import UIKit

// MARK: - AppLanguageView

final class AppLanguageView: UIView {

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

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: LanguageViewModel = .init(languageList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.identifier)
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
        tableProvider?.registerCells([LanguageCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: LanguageCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            if let currentIndex = tableModel.items.firstIndex(where: { $0.isSelected }) {
                languageList[currentIndex].isSelected = false
            }
            languageList[indexPath.section].isSelected = true
            tableModel = .init(languageList)
            tableProvider?.setViewModel(with: tableModel)
            tableView.reloadData()
        }
    }
}

private var languageList: [LanguageItem] = [
    .init(currentLanguage: "Русский язык", nativeLanguage: "Russian", isSelected: true),
    .init(currentLanguage: "Как в системе", nativeLanguage: "Как в системе (Русский)", isSelected: false),
    .init(currentLanguage: "Французский язык", nativeLanguage: "French", isSelected: false),
    .init(currentLanguage: "Испанский язык", nativeLanguage: "Spanish ", isSelected: false),
    .init(currentLanguage: "Арабский язык", nativeLanguage: "Arabic", isSelected: false),
    .init(currentLanguage: "Немецкий язык", nativeLanguage: "German", isSelected: false),
    .init(currentLanguage: "Английский язык", nativeLanguage: "English", isSelected: false),
    .init(currentLanguage: "Китайский язык", nativeLanguage: "中國人", isSelected: false)
]
