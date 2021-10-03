import UIKit
import PhoneNumberKit

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

    private lazy var view = ProfileDetailView()
    private lazy var profileImage = UIImageView()
    private lazy var cameraButton = UIButton()
    private lazy var statusLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var nameLabel = UILabel()
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
    private var continueButtonDefaultOffset = CGFloat(20)
    private var keyboardObserver: KeyboardObserver?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap(true)
        background(.white())
        addCountryView()
        addCountryLabel()
        addArrowImageView()
        addCountryButton()
        addPhoneView()
        addPhoneTextField()
//        addImageView()
//        addCameraButton()
//        addStatusLabel()
//        addStatusView()
//        addInfoLabel()
//        addInfoView()
//        addNameLabel()
//        addNameField()
//        setupTableView()
//        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func saveData() {
        if phoneTextField.isValidNumber {
            guard let phone = phoneTextField.text else { return }
            profileDetail.number = phone
        } else {
            print("Invalid Phone nUmber")
            return
        }
        profileDetail.info = infoView.text
        profileDetail.status = statusView.text
        profileDetail.name = nameField.text ?? ""
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.statusView.resignFirstResponder()
        self.infoView.resignFirstResponder()
        self.nameField.resignFirstResponder()
    }

    func addImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.profileImage.image = image
                }
        profileDetail.image = image
    }

    func setCountryCode(_ country: CountryCodePickerViewController.Country) {
        phoneTextField.selectedCountry = country
        phoneTextField.defaultRegion = country.code
        countryLabel.text = country.prefix + " " + country.name.firstUppercased
    }

    func subscribeOnKeyboardNotifications() {
        guard keyboardObserver == nil else { return }

        keyboardObserver = KeyboardObserver()
        keyboardObserver?.keyboardWillShowHandler = { [weak self] notification in
            guard
                let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
            }
        }
        keyboardObserver?.keyboardWillHideHandler = { [weak self] _ in
        }
        phoneTextField.becomeFirstResponder()
        styleControls()
    }

    func unsubscribeKeyboardNotifications() {
        keyboardObserver = nil
    }

    func updateViewConstraints(_ offset: CGFloat?, object: UIView) {
        let offset = offset ?? continueButtonDefaultOffset
        object.snp.updateConstraints {
            $0.bottom.equalTo(self.snp_bottomMargin).offset(-offset)
        }
        UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
    }

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

    @objc private func onTextUpdate(textField: PhoneNumberTextField) {
        styleControls()
    }

    @objc private func countryButtonTap() {
        vibrate()
        countryView.animateScaleEffect { self.didTapCountryScene?() }
    }

    // MARK: - Private Methods

    private func addImageView() {
        profileImage.snap(parent: self) {
            $0.image = R.image.profileDetail.mainImage1()
            $0.contentMode = .scaleToFill
        } layout: {
            $0.leading.trailing.top.equalTo($1)
            $0.height.equalTo(377)
        }
    }

    private func addCameraButton() {
        cameraButton.snap(parent: self) {
            $0.setImage(R.image.profileDetail.camera(), for: .normal)
            $0.contentMode = .scaleToFill
            $0.clipCorners(radius: 30)
            $0.background(.darkBlack(0.4))
            $0.addTarget(self, action: #selector(self.addPhoto), for: .touchUpInside)
        } layout: {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo($1).offset(-16)
            $0.top.equalTo($1).offset(301)
        }
    }

    private func addStatusLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        statusLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailStatusLabel(),
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
            $0.top.equalTo($1).offset(399)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addStatusView() {
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
            $0.height.greaterThanOrEqualTo(24)
            $0.top.equalTo(self.statusLabel.snp.bottom).offset(8)
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
            $0.top.equalTo(self.statusView.snp_bottomMargin).offset(30)
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
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(132)
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(8)
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
            $0.top.equalTo(self.infoView.snp.bottom).offset(24)
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
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.placeholder = R.string.localizable.profileDetailNameLabel()
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addCountryView() {
        countryView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo($1).offset(50)
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
            $0.leading.equalTo(self.countryLabel.snp.trailing).offset(16)
            $0.trailing.equalTo($1).offset(-10)
            $0.width.height.equalTo(24)
        }
    }

    private func addCountryButton() {
        countryButton.snap(parent: countryView) {
            $0.background(.clear)
            $0.addTarget(self, action: #selector(self.countryButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addPhoneView() {
        phoneView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.countryView.snp.bottom).offset(32)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.equalTo(44)
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
            $0.addTarget(self, action: #selector(self.onTextUpdate), for: .editingChanged)
        } layout: {
            $0.top.bottom.equalTo($1)
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
            $0.top.equalTo(self.nameField.snp.bottom).offset(24)
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

    private func styleControls() {
        let title = R.string.localizable.registrationContinueButton()
    }

    // MARK: - CustomTextField

    final class CustomTextField: PhoneNumberTextField {

        // MARK: - Internal Properties

        var selectedCountry = CountryCodePickerViewController.baseCountry

        override var defaultRegion: String {
            get { selectedCountry?.code ?? PhoneHelper.userRegionCode }
            set {}
        }
    }
}

var profileDetail = ProfileItem(image: R.image.profileDetail.mainImage1()!,
                                status: "На расслабоне на чиле",
                                info: "Сейчас пойду пивка бахну",
                                name: "",
                                code: "+7",
                                number: "8911324567")

var tableList: [ProfileDetailItem] = [
    ProfileDetailItem(text: R.string.localizable.profileDetailFirstItemCell(),
                      image: R.image.profileDetail.firstItem(),
                      type: 0),
    ProfileDetailItem(text: R.string.localizable.profileDetailSecondItemCell(),
                      image: R.image.profileDetail.secondItem(),
                      type: 1),
    ProfileDetailItem(text: R.string.localizable.profileDetailThirdItemCell(),
                      image: R.image.profileDetail.thirdItem(),
                      type: 1)
]
