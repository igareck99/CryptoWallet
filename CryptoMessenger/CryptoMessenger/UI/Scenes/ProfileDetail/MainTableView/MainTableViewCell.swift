import UIKit

// MARK: - MainTableViewCell

final class MainTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var statusLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var telephoneLabel = UILabel()
    private lazy var statusView = UITextView()
    private lazy var infoView = UITextView()
    private lazy var nameField = UITextField()
    private lazy var countryView = UIView()
    private lazy var countryLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    private lazy var countryButton = UIButton()
    private lazy var phoneView = UIView()
    private lazy var phoneTextField = CustomTextField()
    private lazy var lineView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: ProfileDetailViewModel = .init(tableList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addCellLabel()
        addTextView()
        addInfoLabel()
        addNameLabel()
        addNameField()
//        addCountryView()
//        addCountryLabel()
//        addArrowImageView()
//        addCountryButton()
//        addPhoneView()
//        addPhoneTextField()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: MainTableItem) {
        statusLabel = profile.statusLabel
        infoLabel = profile.infoLabel
        nameLabel = profile.nameLabel
        statusView = profile.statusView
        infoView = profile.infoView
        nameField = profile.nameField
        countryView = profile.countryView
        countryLabel = profile.countryLabel
        arrowImageView = profile.arrowImageView
        countryButton = profile.countryButton
        phoneView = profile.statusLabel
        phoneTextField = profile.phoneTextField
    }

    // MARK: - Private Methods

    private func addCellLabel() {
        statusLabel.snap(parent: self) {
            $0.isEnabled = false
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.22
            paragraphStyle.alignment = .center
            $0.titleAttributes(
                text: R.string.localizable.profileDetailStatusLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addTextView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        statusView.snap(parent: self) {
            $0.text = profileDetail.status
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.returnKeyType = UIReturnKeyType.default
            $0.textAlignment = .left
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.isScrollEnabled = false
        } layout: {
            $0.height.greaterThanOrEqualTo(44)
            $0.top.equalTo($1).offset(54)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addInfoLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        infoLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailInfoLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(122)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addInfoView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        infoView.snap(parent: self) {
            $0.text = profileDetail.info
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.returnKeyType = UIReturnKeyType.default
            $0.textAlignment = .left
            $0.background(.lightBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(132)
            $0.top.equalTo(self.statusLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        nameLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailNameLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(308)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addNameField() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        nameField.snap(parent: self) {
            $0.titleAttributes(
                text: profileDetail.name,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.textAlignment = .left
            $0.background(.lightBlue())
            $0.clipCorners(radius: 8)
            $0.placeholder = R.string.localizable.profileDetailNameLabel()
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo($1).offset(338)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addTelephoneLabel() {
        telephoneLabel.snap(parent: self) {
            $0.isEnabled = false
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.22
            paragraphStyle.alignment = .center
            $0.titleAttributes(
                text: "НОМЕР ТЕЛЕФОНА",
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(406)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addPhoneView() {
        phoneView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.telephoneLabel.snp.bottom).offset(32)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.equalTo(44)
        }
    }

    private func addCountryView() {
        countryView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo($1).offset(436)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.equalTo(44)
        }
    }

    private func addCountryLabel() {
        countryLabel.snap(parent: countryView) {
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .left
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: countryView) {
            $0.image = R.image.registration.arrow()
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-10)
            $0.width.height.equalTo(24)
        }
    }

    private func addCountryButton() {
        countryButton.snap(parent: countryView) {
            $0.background(.clear)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addPhoneTextField() {
        phoneTextField.snap(parent: phoneView) {
            $0.placeholder = R.string.localizable.profileDetailPhonePlaceholder()
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .left
            $0.autocorrectionType = .no
            $0.withPrefix = false
            $0.withFlag = false
            $0.maxDigits = 16
        } layout: {
            $0.top.bottom.equalTo($1).offset(12)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo(self.phoneTextField.snp.bottom).offset(24)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([ProfileDetailCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: ProfileDetailCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onViewForHeaderInSection = { [unowned self] section in
            let height = tableModel.heightForHeader(atIndex: section)
            guard height > 0 else { return nil }
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(height)))
            let line = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            line.background(.gray(0.4))
            header.addSubview(line)
            line.center = header.center
            return header
        }
    }

}
