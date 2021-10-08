import UIKit

// MARK: - ProfileDetailView

final class ProfileDetailView: UIView {

    // MARK: - Type

    typealias Country = CountryCodePickerViewController.Country

    // MARK: - Internal Properties

    var didTapReady: VoidBlock?
    var didDeleteTap: VoidBlock?
    var didLogoutTap: VoidBlock?
    var didTapAddPhoto: VoidBlock?
    var didTapCountryScene: VoidBlock?

    // MARK: - Private Properties

    private var profileImage = UIImageView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap(true)
        background(.white())
        addTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    // MARK: - Actions

    @objc func deleteAccount() {
        didDeleteTap?()
    }

    @objc func logout() {
        didLogoutTap?()
    }

    @objc private func addPhoto() {
        didTapAddPhoto?()
    }

    @objc private func countryButtonTap() {
        vibrate()
    }

    // MARK: - Private Methods

    private func addTableView() {
        tableView.snap(parent: self) {
            $0.separatorStyle = .none
            $0.allowsSelection = true
        } layout: {
            $0.leading.trailing.top.bottom.equalTo($1)
        }
    }

    private func setupTableProvider() {
        let viewModel: ProfileDetailViewModel = .init(ProfileDetailItem())
        tableProvider = TableViewProvider(for: tableView, with: viewModel)
        tableProvider?.registerCells([ProfileDetailCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = tableProvider else { return .init() }

            let type = ProfileDetailViewModel.SectionType.allCases[indexPath.section]
            switch type {
            case .status, .description, .name:
                let cell: ProfileDetailCell = provider.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                return cell
            case .countryCode, .phoneNumber:
                // тут своя ячейка
                return .init()
            case .socialNetwork, .exit, .removeAccount:
                // тут своя ячейка
                return .init()
            }
        }
        tableProvider?.onViewForHeaderInSection = {
            viewModel.headerView(atIndex: $0)
        }
    }
}

extension ProfileDetailView: ProfileDetailDelegate {
    func update(_ cell: UITableViewCell, _ textView: UITextView) {
        if let indexPath = tableView.indexPath(for: cell) {
            _ = textView.text ?? ""
            let type = ProfileDetailViewModel.SectionType.allCases[indexPath.section]
            switch type {
            case .status, .description, .name:
                // тут можно обработать сохранение новых данных
                break
            default:
                break
            }
        }

        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(
            CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
        )
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

var profileDetail = ProfileItem(image: R.image.profileDetail.mainImage1()!,
                                status: "На расслабоне на чиле",
                                info: "Сейчас пойду пивка бахну",
                                name: "",
                                code: "+7",
                                number: "8911324567")
