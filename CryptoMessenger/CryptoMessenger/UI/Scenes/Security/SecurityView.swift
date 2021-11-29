import UIKit

// MARK: - SecurityView

final class SecurityView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?
    var didBlackListTap: VoidBlock?
    var didProfileViewingTap: VoidBlock?
    var didSessionTap: VoidBlock?
    var didFalsePasswordTap: VoidBlock?
    var didCreateFalsePasswordTap: VoidBlock?
    var didAuthTap: VoidBlock?
    var didPinCodeTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: SecurityProviderViewModel = .init(securityList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }
    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        userFlows.isPinCodeOn = false
        userCredentials.userPinCode = ""
        userCredentials.userFalsePinCode = ""
        userFlows.isFalsePinCodeOn = false
        setupTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func addCells() {
        securityList.insert(additionalSecurityList[0], at: 1)
        securityList.insert(additionalSecurityList[1], at: 2)
    }

    func removeCells() {
        securityList.removeSubrange(1...2)
    }

    func setVisibleProfile(state: String) {
        guard let index = securityList.firstIndex(where: { $0.title == "Просмотр профиля" }) else { return }
        securityList[index].currentState = state
        tableModel = .init(securityList)
        tableProvider?.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.separatorStyle = .none
            $0.allowsSelection = true
        } layout: {
            $0.leading.trailing.top.bottom.equalTo($1)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([SecurityCell.self, BlackListCell.self, PrivacyCell.self,
                                      SecurityAdditionalCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            if !userFlows.isPinCodeOn {
                guard let provider = self.tableProvider else { return .init() }
                var type = SecurityProviderViewModel.SectionType.allCases[0]
                if indexPath.section == 0 {
                    type = SecurityProviderViewModel.SectionType.allCases[0]
                }
                if indexPath.section == 7 {
                    type = SecurityProviderViewModel.SectionType.allCases[2]
                }
                if indexPath.section != 0 && indexPath.section != 7 {
                    type = SecurityProviderViewModel.SectionType.allCases[1]
                }
                switch type {
                case .security:
                    let cell: SecurityCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    cell.didSwitchTap = {
                        didPinCodeTap?()
                        self.addCells()
                        tableModel = .init(securityList)
                        setupTableProvider()
                    }
                    return cell
                case .blackListUser:
                    let cell: BlackListCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    return cell
                case .privacy:
                    let cell: PrivacyCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    return cell
                default:
                    print("")
                }
            } else {
                guard let provider = self.tableProvider else { return .init() }
                var type = SecurityProviderViewModel.SectionType.allCases[0]
                if indexPath.section == 0 {
                    type = SecurityProviderViewModel.SectionType.allCases[0]
                }
                if indexPath.section == 1 || indexPath.section == 2 {
                    type = SecurityProviderViewModel.SectionType.allCases[3]
                }
                if indexPath.section == 9 {
                    type = SecurityProviderViewModel.SectionType.allCases[2]
                }
                if indexPath.section >= 3 && indexPath.section <= 8 {
                    type = SecurityProviderViewModel.SectionType.allCases[1]
                }
                switch type {
                case .security:
                    let cell: SecurityCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    cell.didSwitchTap = {
                        self.removeCells()
                        tableModel = .init(securityList)
                        setupTableProvider()
                    }
                    return cell
                case .blackListUser:
                    let cell: BlackListCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    return cell
                case .privacy:
                    let cell: PrivacyCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    return cell
                case .additionalSecurity:
                    let cell: SecurityAdditionalCell = provider.dequeueReusableCell(for: indexPath)
                    cell.configure(securityList[indexPath.section])
                    if indexPath.section == 1 {
                        cell.didAuthTap = {
                            didAuthTap?()
                        }
                    }
                    if indexPath.section == 2 {
                        cell.didFalseTap = {
                            falsePasswordCalled = true
                            userFlows.isFalsePinCodeOn = true
                            print(userFlows.isFalsePinCodeOn)
                            didCreateFalsePasswordTap?()
                        }
                    }
                    return cell
                }
            }
            return UITableViewCell()
        }
        tableProvider?.onSelectCell = { [unowned self] indexPath in
            if userFlows.isPinCodeOn == false {
                if indexPath.section == 1 {
                    didProfileViewingTap?()
                }
                if indexPath.section == 6 {
                    didSessionTap?()
                }
                if indexPath.section == 7 {
                    didBlackListTap?()
                }
            } else {
                if indexPath.section == 3 {
                    didProfileViewingTap?()
                }
                if indexPath.section == 8 {
                    didSessionTap?()
                }
                if indexPath.section == 9 {
                    didBlackListTap?()
                }
            }
        }
        tableProvider?.onViewForHeaderInSection = { [unowned self] section in
            if userFlows.isPinCodeOn == false {
                let height = tableModel.heightForHeader(atIndex: section)
                guard height > 0 else { return nil }
                if section == 0 {
                    return SecurityHeaderView()
                }
                if section == 1 {
                    return PrivacyHeaderView()
                }
                return UIView()
            } else {
                let height = tableModel.heightForHeader(atIndex: section)
                guard height > 0 else { return nil }
                if section == 0 {
                    return SecurityHeaderView()
                }
                if section == 3 {
                    return PrivacyHeaderView()
                }
                return UIView()
            }
        }
    }
}

var securityList: [SecurityItem] = [
    .init(title: "PIN-код", currentState: ""),
    .init(title: "Просмотр профиля", currentState: "Все пользователи"),
    .init(title: "Последнее посещение", currentState: "Все поль...тели"),
    .init(title: "Звонки", currentState: "Только мои контакты"),
    .init(title: "Геопозиция", currentState: "Только мои контакты"),
    .init(title: "Номер телефона", currentState: "Только мои контакты"),
    .init(title: "Управление сессиями", currentState: "Показ...устройств"),
    .init(title: "Черный список", currentState: "4")
]

var additionalSecurityList = [
    SecurityItem(title: "Вход по опечатку/ face ID", currentState: "Разрешить вход по отпечатку / лицу"),
    SecurityItem(title: "Ложный пароль", currentState: "Позволяет быстро удалить данные")
]

var falsePasswordCalled = false
