import UIKit

// MARK: - TypographyView

final class TypographyView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: TypographyViewModel = .init(typographyList) {
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
            $0.register(TypographyCell.self, forCellReuseIdentifier: TypographyCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(16)
        }
    }

    private func setupTableProvider() {
        setSize()
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([TypographyCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: TypographyCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            if let currentIndex = tableModel.items.firstIndex(where: { $0.isSelected }) {
                typographyList[currentIndex].isSelected = false
            }
            typographyList[indexPath.section].isSelected = true
            setSize()
            tableModel = .init(typographyList)
            tableProvider?.setViewModel(with: tableModel)
            tableView.reloadData()
        }
    }

    private func setSize() {
        let currentIndex = typographyList.firstIndex(where: { $0.isSelected })
        switch currentIndex {
        case 0:
            mainFont = 15
            nativeFont = 13
            cellSize = 64
        case 1:
            mainFont = 19
            nativeFont = 17
            cellSize = 78
        case 2:
            mainFont = 23
            nativeFont = 21
            cellSize = 90
        default:
            break
        }
    }
}

var mainFont: CGFloat = 0
var nativeFont: CGFloat = 0
var cellSize: CGFloat = 0

var typographyList: [TypographyItem] = [
    .init(name: "Мелкий", size: "80%", isSelected: true),
    .init(name: "Средний", size: "Как в системе (Русский)", isSelected: false),
    .init(name: "Большой", size: "120%", isSelected: false)
]
