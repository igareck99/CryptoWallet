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

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    var selectedCountry = CountryCodePickerViewController.baseCountry

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap()
        background(.white())
        addTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func addImage(image: UIImage) {
        profileDetail.image = image
        let headerView = ProfileDetailTableHeaderView(
            frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        )
        tableView.tableHeaderView = headerView
    }

    func saveData() {
        print(profileDetail)
    }

    // MARK: - Actions

    @objc private func deleteAccount() {
        didDeleteTap?()
    }

    @objc private func logout() {
        didLogoutTap?()
    }

    @objc private func addPhoto() {
        didTapAddPhoto?()
    }

    @objc private func countryButtonTap() {
        didTapCountryScene?()
        vibrate()
    }

    // MARK: - Private Methods

    private func addTableView() {
        let headerView = ProfileDetailTableHeaderView(
            frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        )
        headerView.didCameraTap = {
            self.addPhoto()
        }

        tableView.snap(parent: self) {
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.tableHeaderView = headerView
        } layout: {
            $0.leading.trailing.top.bottom.equalTo($1)
        }
    }

    private func setupTableProvider() {
        let viewModel: ProfileDetailViewModel = .init(ProfileDetailItem())
        tableProvider = TableViewProvider(for: tableView, with: viewModel)
        tableProvider?.registerCells([ProfileDetailCell.self, ProfileActionCell.self, ProfileCountryCodeCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = tableProvider else { return .init() }
            let type = ProfileDetailViewModel.SectionType.allCases[indexPath.section]
            switch type {
            case .status, .description, .name, .phoneNumber:
                let cell: ProfileDetailCell = provider.dequeueReusableCell(for: indexPath)
                var text = ""
                switch type {
                case .status:
                    text = profileDetail.status
                case .description:
                    text = profileDetail.description
                case .name:
                    text = profileDetail.name
                case .phoneNumber:
                    text = profileDetail.phone
                default:
                    break
                }
                cell.configure(text)
                cell.delegate = self
                return cell
            case .countryCode:
                let cell: ProfileCountryCodeCell = provider.dequeueReusableCell(for: indexPath)
                cell.configure(profileDetail.countryCode)
                return cell
            case .socialNetwork, .exit, .deleteAccount:
                let cell: ProfileActionCell = provider.dequeueReusableCell(for: indexPath)
                cell.configure(type)
                return cell
            }
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            let type = ProfileDetailViewModel.SectionType.allCases[indexPath.section]
            switch type {
            case .countryCode:
                countryButtonTap()
            case .deleteAccount:
                print("delete")
                deleteAccount()
            case .exit:
                logout()
            default:
                print("")
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
            case .status:
                profileDetail.status = textView.text
            case .description:
                profileDetail.description = textView.text
            case .name:
                profileDetail.name = textView.text
            case .phoneNumber:
                profileDetail.phone = textView.text
            case .countryCode:
                profileDetail.countryCode = textView.text
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

var profileDetail : ProfileDetailItem = ProfileDetailItem(image: R.image.profileDetail.mainImage1(),
                                                          status: "AURA Россия",
                                                          description: "Делаю лучший крипто-мессенджер!\nЖиву в Зеленограде! Люблю качалку:)",
                                                          name: "Артём Квач",
                                                          countryCode: "+7  Россия",
                                                          phone: "(925) 851-15-41")
