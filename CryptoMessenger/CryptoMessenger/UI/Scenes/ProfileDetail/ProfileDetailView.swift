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

    private var mainTableList: [MainTableItem] = []
    private var profileImage = UIImageView()
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
    private lazy var mainTableView = UITableView(frame: .zero, style: .plain)
    private var MainTableProvider: TableViewProvider?
    private var continueButtonDefaultOffset = CGFloat(20)
    private var keyboardObserver: KeyboardObserver?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap(true)
        background(.white())
        addActions()
        setupMainTableView()
        setupMainTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func addActions() {
        countryButton.addTarget(self, action: #selector(self.countryButtonTap), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(self.addPhoto), for: .touchUpInside)
    }

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

    @objc private func countryButtonTap() {
        vibrate()
        countryView.animateScaleEffect { self.didTapCountryScene?() }
    }

    // MARK: - Private Methods

    private func setupMainTableView() {
        mainTableView.snap(parent: self) {
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
            $0.separatorStyle = .none
            $0.isUserInteractionEnabled = false
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.top.bottom.equalTo($1)
        }
    }

    private func setupMainTableProvider() {
        var MainTableModel: MainTableViewModel = .init([MainTableItem(statusLabel: statusLabel,
                                                                     infoLabel: infoLabel,
                                                                     nameLabel: nameLabel,
                                                                     statusView: statusView,
                                                                     infoView: infoView,
                                                                     nameField: nameField,
                                                                     countryView: countryView,
                                                                     countryLabel: countryLabel,
                                                                     arrowImageView: arrowImageView,
                                                                     countryButton: countryButton,
                                                                     phoneView: phoneView,
                                                                     phoneTextField: phoneTextField)])
        MainTableProvider = TableViewProvider(for: mainTableView, with: MainTableModel)
        MainTableProvider?.registerCells([MainTableViewCell.self])
        MainTableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.MainTableProvider else { return .init() }
            let cell: MainTableViewCell = provider.dequeueReusableCell(for: indexPath)
            let item = MainTableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        MainTableProvider?.onViewForHeaderInSection = { [unowned self] section in
            let height = MainTableModel.heightForHeader(atIndex: section)
            guard height > 0 else { return nil }
            let header = HeaderView(frame: CGRect(x: 0, y: 0, width: mainTableView.frame.width,
                                                  height: CGFloat(height)),
                                                  button: cameraButton, imageView: profileImage)
            return header
        }
    }
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
